import AuthService from '../services/AuthService';
import { TokenManager } from '../utils/TokenManager';
import { LoginRequest, RegisterRequest, LoginResult } from '../models/LoginModel';

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
}

export default new AuthViewModel();
