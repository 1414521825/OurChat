import { MessageItem } from '../models/MessageModel';
import MessageService from '../services/MessageService';
import { TokenManager } from '../utils/TokenManager';

class MessageViewModel {
  private chatListData: MessageItem[] = [];

  async getChatList(): Promise<MessageItem[]> {
    try {
      const token = await TokenManager.getToken();
      this.chatListData = await MessageService.fetchChatListFromServer(token);
    } catch (e) {
      console.error('获取消息列表失败：' + (e as Error).message);
      this.chatListData = [];  // 失败返回空列表，UI 不至于崩溃
    }
    return this.chatListData;
  }

  clearUnreadCount(id: string) {
    let index = this.chatListData.findIndex(item => item.id === id);
    if (index !== -1) {
      this.chatListData[index].unreadCount = 0;
    }
  }

  // 在 MessageViewModel.ets 里加上这个同步方法用于本地刷新
  getChatListSync(): MessageItem[] {
    return this.chatListData;
  }

  // 退出后清空聊天缓存
  clear() {
    this.chatListData.length = 0;
  }
}

export default new MessageViewModel();