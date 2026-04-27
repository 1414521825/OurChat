import { UserProfile } from '../models/ProfileModel';
import ProfileService from '../services/ProfileService';
import { TokenManager } from '../utils/TokenManager';

class ProfileViewModel {
  // View 可以通过这个字段判断当前数据是否来自缓存
  fromCache: boolean = false;

  async getMyProfile(): Promise<UserProfile> {
    try {
      const token = await TokenManager.getToken();
      const profile = await ProfileService.fetchMyProfile(token);
      this.fromCache = ProfileService.isFromCache(profile);
      return profile;
    } catch (e) {
      console.error('获取个人资料失败：' + (e as Error).message);
      this.fromCache = false;
      return new UserProfile('', '', '');
    }
  }
}

export default new ProfileViewModel();
