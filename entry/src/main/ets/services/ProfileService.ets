import { UserProfile } from '../models/ProfileModel';
import { http } from '@kit.NetworkKit';
import { ApiResponse } from '../models/LoginModel';

// TODO: 替换为你的后端服务器地址
const BASE_URL = 'https://your-server.com';

class ProfileService {
  // 内存缓存，APP 运行期间有效。网络失败时用它兜底
  private cachedProfile: UserProfile | null = null;

  async fetchMyProfile(token: string): Promise<UserProfile> {
    console.info('Service: 正在拉取用户个人信息...');
    const httpRequest = http.createHttp();
    try {
      const response = await httpRequest.request(
        `${BASE_URL}/api/user/profile`,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
          connectTimeout: 10000,
          readTimeout: 10000
        }
      );

      const result: ApiResponse<UserProfile> = JSON.parse(response.result as string);
      if (result.code === 0) {
        const profile = new UserProfile(
          result.data.id,
          result.data.name,
          result.data.bio
        );
        // 成功时更新缓存
        this.cachedProfile = profile;
        return profile;
      } else {
        throw new Error(result.message || '获取个人资料失败');
      }
    } catch (e) {
      // 网络失败时尝试用缓存兜底
      if (this.cachedProfile) {
        console.info('Service: 网络不可用，使用缓存数据');
        return this.cachedProfile;
      }
      throw new Error((e as Error).message || '获取个人资料失败');
    } finally {
      httpRequest.destroy();
    }
  }

  // 检查上一次返回的是否是缓存数据（ViewModel 用来通知 View 展示提示）
  isFromCache(profile: UserProfile): boolean {
    return this.cachedProfile === profile;
  }
}

export default new ProfileService();
