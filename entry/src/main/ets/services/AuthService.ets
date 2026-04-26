import { http } from '@kit.NetworkKit';
import { LoginRequest, RegisterRequest, ApiResponse, LoginData } from '../models/LoginModel';

// TODO: 替换为你的后端服务器地址
const BASE_URL = 'https://your-server.com';

class AuthService {
  async login(request: LoginRequest): Promise<LoginData> {
    // 1. 创建 HTTP 客户端实例
    const httpRequest = http.createHttp();

    try {
      // 2. 发请求
      const response = await httpRequest.request(
        `${BASE_URL}/api/auth/login`,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify(request), // 把请求体对象转为 JSON 字符串
          connectTimeout: 10000,              // 连接超时 10 秒
          readTimeout: 10000                  // 读取超时 10 秒
        }
      );

      // 3. 解析响应。response.result 的类型取决于返回的 Content-Type，
      //    后端返回 JSON 时它是 string，需要手动 JSON.parse
      const result: ApiResponse<LoginData> = JSON.parse(response.result as string);

      // 4. 判断业务状态码
      if (result.code === 0) {
        return result.data;
      } else {
        // 后端返回了业务错误（如密码错误）
        throw new Error(result.message || '登录失败');
      }
    } finally {
      // 5. 无论成功还是失败，都要销毁客户端释放资源
      httpRequest.destroy();
    }
  }

  async register(request: RegisterRequest): Promise<LoginData> {
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(
        `${BASE_URL}/api/auth/register`,
        {
          method: http.RequestMethod.POST,
          header: { 'Content-Type': 'application/json' },
          extraData: JSON.stringify(request),
          connectTimeout: 10000,
          readTimeout: 10000
        }
      );

      const result: ApiResponse<LoginData> = JSON.parse(response.result as string);

      if (result.code === 0) {
        return result.data;
      } else {
        throw new Error(result.message || '注册失败');
      }
    } finally {
      httpRequest.destroy();
    }
  }
}

export default new AuthService();
