import { preferences } from '@kit.ArkData';

const STORE_NAME = 'auth_preferences';
const KEY_TOKEN = 'auth_token';
const KEY_USER_ID = 'user_id';

export class TokenManager {
  private static store?: preferences.Preferences;

  // 在 EntryAbility.onCreate 中调用，传入 context 来初始化
  static async init(context: Context): Promise<void> {
    TokenManager.store = await preferences.getPreferences(context, STORE_NAME);
  }

  static async saveToken(token: string): Promise<void> {
    await TokenManager.store?.put(KEY_TOKEN, token);
    await TokenManager.store?.flush();
  }

  static async getToken(): Promise<string> {
    if (!TokenManager.store) {
      return '';
    }
    return await TokenManager.store.get(KEY_TOKEN, '') as string;
  }

  static async saveUserId(userId: string): Promise<void> {
    await TokenManager.store?.put(KEY_USER_ID, userId);
    await TokenManager.store?.flush();
  }

  static async getUserId(): Promise<string> {
    if (!TokenManager.store) {
      return '';
    }
    return await TokenManager.store.get(KEY_USER_ID, '') as string;
  }

  static async clear(): Promise<void> {
    await TokenManager.store?.delete(KEY_TOKEN);
    await TokenManager.store?.delete(KEY_USER_ID);
    await TokenManager.store?.flush();
  }

  // 判断是否已登录：token 存在且不为空
  static async isLoggedIn(): Promise<boolean> {
    const token = await TokenManager.getToken();
    return token !== '';
  }
}
