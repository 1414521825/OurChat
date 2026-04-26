// 用户个人资料的数据结构
@Observed
export class UserProfile {
  id: string;        // 唯一标识
  name: string;      // 用户昵称
  bio: string;       // 个性签名

  constructor(id: string, name: string, bio: string) {
    this.id = id;
    this.name = name;
    this.bio = bio;
  }
}
