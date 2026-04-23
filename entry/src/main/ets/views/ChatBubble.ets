import { ChatMessage } from "../models/ChatMessageModel";

@Component
export struct ChatBubble {
  message: ChatMessage = new ChatMessage('', '', '');

  build() {
    Row() {
      if (this.message.senderId == 'me') {
        // 【我发的消息：靠右，蓝色背景】
        Blank();
        Text(this.message.text)
          .backgroundColor('#007DFF')
          .fontColor(Color.White)
          .padding(12)
          .borderRadius({ topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 0 })
      }
      else {
        // 【对方的消息：靠左，灰色背景】
        Circle({ width: 40, height: 40 }).fill('#E0E0E0').margin({ right: 10 }) // 对方头像
        Text(this.message.text)
          .backgroundColor('#F1F3F5')
          .fontColor(Color.Black)
          .padding(12)
          .borderRadius({ topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 10 })
        Blank()
      }
    }
    .width('100%')
    .padding({ left: 15, right: 15 })
  }
}