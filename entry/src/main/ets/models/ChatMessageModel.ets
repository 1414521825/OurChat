export class ChatMessage {
  id: string;
  senderId: string; // 发送者ID（如果是 'me' 代表自己发的消息，显示在右边）
  text: string;     // 消息内容

  constructor(id: string, senderId: string, text: string) {
    this.id = id;
    this.senderId = senderId;
    this.text = text;
  }
}