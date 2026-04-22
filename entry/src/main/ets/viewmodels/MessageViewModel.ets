import { MessageItem } from '../models/MessageModel';
import MessageService from '../services/MessageService';

class MessageViewModel {
  private chatListData: MessageItem[] = [];

  // 获取数据的方法变成了异步的，因为它要等 Service 把数据取回来
  async getChatList(): Promise<MessageItem[]> {
    // 调用 Service 层真正获取数据
    this.chatListData = await MessageService.fetchChatListFromServer();

    // 如果拿到数据后需要做些特殊处理（比如过滤黑名单用户），也是在这里做
    // ...

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
}

export default new MessageViewModel();