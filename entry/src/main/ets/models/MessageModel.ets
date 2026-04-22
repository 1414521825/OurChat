// 定义聊天记录的数据结构
@Observed
export class MessageItem {
  id: string;          // 唯一标识
  name: string;        // 用户昵称
  lastMessage: string; // 最新消息
  time: string;        // 消息时间
  unreadCount: number; // 未读消息数量

  constructor(id: string, name: string, lastMessage: string, time: string, unreadCount: number = 0) {
    this.id = id;
    this.name = name;
    this.lastMessage = lastMessage;
    this.time = time;
    this.unreadCount = unreadCount;
  }
}