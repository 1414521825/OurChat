import { UserProfile } from '../models/ProfileModel';

class ProfileService {
  // 模拟从服务器拉取当前用户个人信息
  async fetchMyProfile(): Promise<UserProfile> {
    console.info('Service: 正在拉取用户个人信息...');
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(new UserProfile('me', '用户昵称', '这个人很懒，什么都没写'));
      }, 500); // 模拟 500ms 网络延迟
    });
  }
}

export default new ProfileService();
