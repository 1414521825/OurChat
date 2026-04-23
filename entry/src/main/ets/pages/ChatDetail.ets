import { ChatMessage } from '../models/ChatMessageModel';
import ChatDetailViewModel from '../viewmodels/ChatDetailViewModel';
import { router } from '@kit.ArkUI';
import { ChatInputArea } from '../views/ChatInputArea';
import { ChatBubble } from '../views/ChatBubble';

@Component
export struct ChatDetail {
  // 1. 先赋初始值
  @State contactName: string = '聊天';
  @State contactId: string = '';
  @State messageList: ChatMessage[] = [];
  @State inputText: string = '';
  @State isLoading: boolean = true;
  @State isSending: boolean = false;
  @State isAtBottom: boolean = false;
  @State unreadCount: number = 0;

  // 🌟 核心 1：接收路由栈
  @Consume('pageStack') pageStack: NavPathStack;

  private scroller: Scroller = new Scroller();

  // 【新增】异步加载历史记录
  async loadHistory() {
    this.isLoading = true;
    // 等待 ViewModel 去找 Service 拿数据（会触发 0.5 秒延迟）
    let data = await ChatDetailViewModel.getHistoryMessages(this.contactId);
    this.messageList = [...data];
    this.isLoading = false;

    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom)
    }, 100)
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

    // 🌟【新增】让列表滚动到最底部
    // 💡 架构师细节：这里用 setTimeout 延迟 100 毫秒，是因为 push 数据后，
    // ArkUI 需要一瞬间的时间去把新气泡“画”到屏幕上。画完之后再滚，才能完美触底。
    setTimeout(() => {
      this.scroller.scrollEdge(Edge.Bottom)
      this.unreadCount = 0;
    }, 100)
  }

  build() {
    NavDestination() {
      Column() {
        // --- 1. 顶部导航栏 ---
        Row() {
          Text('〈 返回')
            .fontSize(16)
            .fontColor('#007DFF')
            .padding(10)
            .onClick(() => {
              // 🌟 核心 3：使用 pop() 返回上一页
              this.pageStack.pop();
            })

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
          Stack({ alignContent: Alignment.BottomEnd }) {
            List({ space: 20, scroller: this.scroller }) {
              ForEach(this.messageList, (item: ChatMessage) => {
                ListItem() {
                  ChatBubble({ message: item })
                }
              }, (item: ChatMessage) => item.id)
            }
            .width('100%')
            .height('100%')
            .padding({ top: 10, bottom: 10 })
            .onScrollIndex((firstIndex: number, lastIndex: number) => {
              this.isAtBottom = (lastIndex >= this.messageList.length - 1);
              if (this.isAtBottom) {
                this.unreadCount = 0; // 到底部了，清空提示
              }
            })

            // 👈 [新增] 悬浮按钮：只有不在底部，且有新消息时才显示
            if (!this.isAtBottom && this.unreadCount > 0) {
              Button(`↓ ${this.unreadCount} 条新消息`)
                .height(32)
                .fontSize(14)
                .backgroundColor(Color.White)
                .fontColor('#007DFF')
                .border({ width: 1, color: '#007DFF', radius: 16 })
                .margin({ bottom: 20, right: 20 })
                .shadow({ radius: 5, color: 'rgba(0,0,0,0.1)' })
                .onClick(() => {
                  this.scroller.scrollEdge(Edge.Bottom);
                })
            }
          }
          .width('100%')
          .layoutWeight(1)
          .backgroundColor('#FFFFFF')
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
    .hideTitleBar(true)
    // 🌟 核心 4：在 onReady 生命周期中安全地获取跳转参数
    .onReady((context: NavDestinationContext) => {
      let params = context.pathInfo.param as Record<string, string>;
      if (params) {
        this.contactName = params['name'] || '聊天';
        this.contactId = params['id'] || '';
      }
      this.loadHistory();
    })
  }
}