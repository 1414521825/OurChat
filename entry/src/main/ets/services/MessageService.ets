import { http } from '@kit.NetworkKit';
import { MessageItem } from '../models/MessageModel';
import { ApiResponse } from '../models/LoginModel';

// TODO: 替换为你的后端服务器地址
const BASE_URL = 'https://your-server.com';

class MessageService {
  async fetchChatListFromServer(token: string): Promise<MessageItem[]> {
    const httpRequest = http.createHttp();

    try {
      const response = await httpRequest.request(
        `${BASE_URL}/api/messages/list`,
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`  // 鉴权头，后端通过它识别当前用户
          },
          connectTimeout: 10000,
          readTimeout: 10000
        }
      );

      const result: ApiResponse<MessageItem[]> = JSON.parse(response.result as string);

      if (result.code === 0) {
        // JSON.parse 生成的是普通对象，必须转成 MessageItem 实例，
        // 因为 @Observed 装饰的类需要真正的类实例才能被 @ObjectLink 追踪
        return result.data.map((item: MessageItem) =>
          new MessageItem(item.id, item.name, item.lastMessage, item.time, item.unreadCount)
        );
      } else {
        throw new Error(result.message || '获取消息列表失败');
      }
    } finally {
      httpRequest.destroy();
    }
  }
}

export default new MessageService();