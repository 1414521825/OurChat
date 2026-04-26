import { UserProfile } from '../models/ProfileModel';
import ProfileService from '../services/ProfileService';

class ProfileViewModel {
  // 获取当前登录用户的个人信息
  async getMyProfile(): Promise<UserProfile> {
    return await ProfileService.fetchMyProfile();
  }
}

export default new ProfileViewModel();
