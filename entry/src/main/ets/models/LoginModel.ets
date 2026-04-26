// 发送给后端登录接口的请求体
export class LoginRequest {
  username: string;
  password: string;

  constructor(username: string, password: string) {
    this.username = username;
    this.password = password;
  }
}

// 发送给后端注册接口的请求体（字段和登录一样，但独立成一个类方便后续扩展）
export class RegisterRequest {
  username: string;
  password: string;

  constructor(username: string, password: string) {
    this.username = username;
    this.password = password;
  }
}

// 后端统一返回格式：{ code: 0 表示成功, message: 提示信息, data: 具体数据 }
export interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}

// 登录成功后返回的 data 字段
export interface LoginData {
  token: string;
  userId: string;
  username: string;
}

// ViewModel 返回给页面的统一结果，ArkTS 要求必须是显式声明的类
export class LoginResult {
  success: boolean;
  message: string;

  constructor(success: boolean, message: string) {
    this.success = success;
    this.message = message;
  }
}
