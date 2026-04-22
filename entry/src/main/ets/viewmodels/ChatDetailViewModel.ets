import { ChatMessage } from '../models/ChatMessageModel';
import ChatService from '../services/ChatService';

class ChatDetailViewModel {

  // 异步获取历史记录，调用 Service
  async getHistoryMessages(contactId: string): Promise<ChatMessage[]> {
    return await ChatService.fetchHistoryMessages(contactId);
  }

  // 处理发送消息的复合逻辑
  async sendMessage(text: string): Promise<ChatMessage> {
    // 1. 组装一条新消息对象
    let newMessage = new ChatMessage(Date.now().toString(), 'me', text);

    // 2. 调用 Service 层，真正发给服务器
    let isSuccess = await ChatService.sendMessageToServer(newMessage);

    if (!isSuccess) {
      // 如果 Service 告诉我们发送失败，我们可以在这里给消息打上失败的标记
      // (比如真实项目中可以在 Model 里加个 status 字段变成 'failed')
      console.error("ViewModel: 糟糕，消息发送失败了！");
    }

    // 3. 将组装好的消息返回给 View 层，让它显示出来
    return newMessage;
  }
}

export default new ChatDetailViewModel();