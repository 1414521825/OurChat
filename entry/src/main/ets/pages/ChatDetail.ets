import { ChatMessage } from '../models/ChatMessageModel';
import ChatDetailViewModel from '../viewmodels/ChatDetailViewModel';
import { router } from '@kit.ArkUI';
import { ChatInputArea } from '../views/ChatInputArea';

@Entry
@Component
struct ChatDetail {
  // 1. 先赋初始值
  @State contactName: string = '聊天';
  @State contactId: string = '';

  @State messageList: ChatMessage[] = [];
  @State inputText: string = '';
  @State isLoading: boolean = true;
  @State isSending: boolean = false;

  aboutToAppear() {
    // 2. 使用官方推荐的上下文路由获取参数 (告别删除线！)
    let params = this.getUIContext().getRouter().getParams() as Record<string, string>;

    // 3. 安全赋值
    if (params) {
      this.contactName = params['name'] || '聊天';
      this.contactId = params['id'] || '';
    }

    // 4. 继续加载历史记录
    this.loadHistory();
  }

  // 【新增】异步加载历史记录
  async loadHistory() {
    this.isLoading = true;
    // 等待 ViewModel 去找 Service 拿数据（会触发 0.5 秒延迟）
    let data = await ChatDetailViewModel.getHistoryMessages(this.contactId);
    this.messageList = [...data];
    this.isLoading = false;
  }

  // 【修改】变成异步发送方法
  async handleSend() {
    // 如果没写字，或者正在发送中，就不执行
    if (this.inputText.trim() === '' || this.isSending) return;

    this.isSending = true;
    // 提前把输入框的字存起来，然后立刻清空输入框，这样用户体验更好（感觉秒发）
    let textToSend = this.inputText;
    this.inputText = '';

    // 等待 ViewModel 去找 Service 发送数据（会触发 0.3 秒延迟）
    let newMessage = await ChatDetailViewModel.sendMessage(textToSend);

    // 把新消息塞进数组里，触发 UI 刷新
    this.messageList.push(newMessage);
    this.isSending = false;
  }

  build() {
    Column() {
      // --- 1. 顶部导航栏 ---
      Row() {
        Text('〈 返回')
          .fontSize(16)
          .fontColor('#007DFF')
          .padding(10)
          .onClick(() => { router.back(); })

        Text(this.contactName)
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .margin({ right: 50 }) // 稍微占位居中
      }
      .width('100%')
      .height(60)
      .backgroundColor('#F8F8F8')

      // --- 2. 聊天记录列表区 ---
      // 根据加载状态决定显示内容
      if (this.isLoading) {
        Column() {
          LoadingProgress().width(40).height(40).color('#007DFF')
          Text('正在加载聊天记录...').fontSize(14).fontColor('#999999').margin({ top: 10 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        List({ space: 20 }) {
          ForEach(this.messageList, (item: ChatMessage) => {
            ListItem() {
              Row() {
                if (item.senderId === 'me') {
                  // 【我发的消息：靠右】
                  Blank()
                  Text(item.text)
                    .backgroundColor('#007DFF')
                    .fontColor(Color.White)
                    .padding(12)
                    .borderRadius({ topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 0 })
                } else {
                  // 【对方的消息：靠左】
                  Circle({ width: 40, height: 40 }).fill('#E0E0E0').margin({ right: 10 })
                  Text(item.text)
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
          }, (item: ChatMessage) => item.id)
        }
        .width('100%')
        .layoutWeight(1)
        .backgroundColor('#FFFFFF')
        .padding({ top: 10, bottom: 10 })
      }

      // --- 3. 底部输入区 ---
      ChatInputArea({
        inputText: $inputText,
        isSending: this.isSending,
        onSend: () => {
          this.handleSend();
        }
      })
    }
    .width('100%')
    .height('100%')
  }
}