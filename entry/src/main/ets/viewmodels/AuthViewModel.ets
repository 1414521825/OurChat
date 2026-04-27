import AuthService from '../services/AuthService';
import { TokenManager } from '../utils/TokenManager';
import { LoginRequest, RegisterRequest, LoginResult, LogoutRequest } from '../models/LoginModel';
import MessageViewModel from './MessageViewModel';

class AuthViewModel {
  async login(username: string, password: string): Promise<LoginResult> {
    if (!username.trim()) {
      return new LoginResult(false, '请输入用户名');
    }
    if (!password) {
      return new LoginResult(false, '请输入密码');
    }

    try {
      const request = new LoginRequest(username.trim(), password);
      const data = await AuthService.login(request);

      await TokenManager.saveToken(data.token);
      await TokenManager.saveUserId(data.userId);

      return new LoginResult(true, '登录成功');
    } catch (e) {
      const msg = (e as Error).message || '网络请求失败，请稍后重试';
      return new LoginResult(false, msg);
    }
  }

  async register(username: string, password: string, confirmPassword: string): Promise<LoginResult> {
    if (!username.trim()) {
      return new LoginResult(false, '请输入用户名');
    }
    if (!password) {
      return new LoginResult(false, '请输入密码');
    }
    if (password !== confirmPassword) {
      return new LoginResult(false, '两次输入的密码不一致');
    }

    try {
      const request = new RegisterRequest(username.trim(), password);
      const data = await AuthService.register(request);

      // 注册成功等同于自动登录，存 token
      await TokenManager.saveToken(data.token);
      await TokenManager.saveUserId(data.userId);

      return new LoginResult(true, '注册成功');
    } catch (e) {
      const msg = (e as Error).message || '网络请求失败，请稍后重试';
      return new LoginResult(false, msg);
    }
  }

  // 开发用：跳过真实 API，直接写入假 token 进入主界面。后端好了删掉这个方法
  async loginDev(): Promise<LoginResult> {
    await TokenManager.saveToken('dev-token-123');
    await TokenManager.saveUserId('dev-user-1');
    return new LoginResult(true, '开发登录成功');
  }

  async logout(): Promise<LoginResult> {
    const userId = await TokenManager.getUserId();

    // 第 1 步：立刻清除本地 token 和所有缓存，让用户直接退出
    await TokenManager.clear();
    MessageViewModel.clear();

    // 第 2 步：异步通知后端，不阻塞 UI（fire-and-forget）
    if (userId) {
      const request = new LogoutRequest(userId);
      AuthService.logout(request).catch((e: Error) => {
        console.error('后端退登通知失败：' + e.message);
      });
    }

    return new LoginResult(true, '已退出登录');
  }
}

export default new AuthViewModel();
