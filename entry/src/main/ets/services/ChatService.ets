import { ChatMessage } from '../models/ChatMessageModel';

class ChatService {
  // 1. 获取历史记录（真正与后台交互的地方）
  async fetchHistoryMessages(contactId: string): Promise<ChatMessage[]> {
    console.info(`Service: 正在从服务器拉取与 ${contactId} 的聊天记录...`);
    // 模拟网络请求
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve([
          new ChatMessage('1', contactId, '你好呀！很高兴认识你~'),
          new ChatMessage('2', 'me', '你好！我是刚刚匹配的。'),
          new ChatMessage('3', contactId, '今天天气不错，你平时喜欢做什么？'),
          new ChatMessage('4', contactId, '你好呀！很高兴认识你~'),
          new ChatMessage('5', 'me', '你好！我是刚刚匹配的。'),
          new ChatMessage('6', contactId, '今天天气不错，你平时喜欢做什么？'),
          new ChatMessage('7', contactId, '你好呀！很高兴认识你~'),
          new ChatMessage('8', 'me', '你好！我是刚刚匹配的。'),
          new ChatMessage('9', contactId, '今天天气不错，你平时喜欢做什么？'),
          new ChatMessage('10', contactId, '你好呀！很高兴认识你~'),
          new ChatMessage('11', 'me', '你好！我是刚刚匹配的。'),
          new ChatMessage('12', contactId, '今天天气不错，你平时喜欢做什么？'),

        ]);
      }, 500);
    });
  }

  // 2. 发送单条消息到服务器（真正访问网络地址的地方）
  async sendMessageToServer(message: ChatMessage): Promise<boolean> {
    console.info(`Service: 正在将消息 "${message.text}" 发往服务器 API 接口...`);
    // 模拟网络请求，假设 99% 的概率发送成功
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(true);
      }, 300);
    });
  }
}

export default new ChatService();