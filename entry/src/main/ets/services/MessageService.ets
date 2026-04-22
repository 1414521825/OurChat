import { MessageItem } from '../models/MessageModel';

class MessageService {
  // 模拟从服务器发起网络请求获取数据
  async fetchChatListFromServer(): Promise<MessageItem[]> {
    // 真实开发中，这里会使用鸿蒙的 @ohos.net.http 发起真实的请求
    console.info("Service: 正在向服务器请求数据...");

    // 我们用 setTimeout 模拟网络延迟（比如等 1 秒钟）
    return new Promise((resolve) => {
      setTimeout(() => {
        let fakeData = [
          new MessageItem('1', 'Alice', '你好呀！很高兴认识你~', '10:30', 2),
          new MessageItem('2', 'Bob', '周末去哪里玩？', '昨天', 0),
          new MessageItem('3', 'Charlie', '代码写完了吗？', '星期一', 5)
        ];
        resolve(fakeData);
      }, 1000); // 模拟 1000 毫秒的请求时间
    });
  }
}

export default new MessageService();