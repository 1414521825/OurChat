import { MessageItem } from '../models/MessageModel';
import MessageViewModel from '../viewmodels/MessageViewModel';

@Component
struct MessageListItem {
  @ObjectLink item: MessageItem;

  build() {
    Row() {
      Badge({ count: this.item.unreadCount, style: { badgeSize: 16, badgeColor: '#FF4500' } }) {
        Circle({ width: 50, height: 50 }).fill('#E0E0E0').margin({ right: 15 })
      }
      Column() {
        Text(this.item.name).fontSize(16).fontWeight(FontWeight.Medium)
        Text(this.item.lastMessage).fontSize(14).fontColor('#999999').margin({ top: 5 }).maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
      }.alignItems(HorizontalAlign.Start).layoutWeight(1)
      Text(this.item.time).fontSize(12).fontColor('#CCCCCC').margin({ left: 10 })
    }
    .width('100%')
    .padding(15)
    .backgroundColor(Color.White)
    .onClick(() => {
      if (this.item.unreadCount > 0) {
        // 通知ViewModel清空红点数据
        MessageViewModel.clearUnreadCount(this.item.id);
      }
      this.getUIContext().getRouter().pushUrl({
        url: 'pages/ChatDetail',
        params: {
          id: this.item.id,
          name: this.item.name
        }
      })
    })
  }
}

@Component
export struct MessagePage {
  @State chatList: MessageItem[] = [];

  // 1. 新增：控制首次进入页面的转圈圈加载状态
  @State isLoading: boolean = true;
  // 2. 新增：控制下拉刷新的状态
  @State isRefreshing: boolean = false;

  aboutToAppear() {
    this.loadData();
  }

  // 3. 将加载方法改为 async 异步，等待 ViewModel 和 Service 的网络请求
  async loadData() {
    // 等待数据返回（这里会触发 Service 里我们写的 1 秒延迟）
    let data = await MessageViewModel.getChatList();
    this.chatList = [...data];

    // 数据拿到了，关闭所有加载动画
    this.isLoading = false;
    this.isRefreshing = false;
  }

  build() {
    Column() {
      // --- 1. 顶部标题栏 ---
      Row() {
        Text('消息')
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
      .height(60)
      .justifyContent(FlexAlign.Center)

      // --- 2. 新匹配区 (保持不变) ---
      Column() {
        Text('新匹配').fontSize(14).fontColor('#666666').margin({ bottom: 10, left: 15 }).width('100%')
        List({ space: 15 }) {
          ForEach([1, 2, 3, 4, 5], (item: number) => {
            ListItem() {
              Column() {
                Circle({ width: 60, height: 60 }).fill('#BBDEFB')
                Text(`匹配 ${item}`).fontSize(12).margin({ top: 5 })
              }
            }
          })
        }.listDirection(Axis.Horizontal).width('100%').height(85).padding({ left: 15, right: 15 }).scrollBar(BarState.Off)
      }.margin({ top: 10, bottom: 20 })

      // --- 3. 动态内容区：根据状态显示 Loading 还是 列表 ---
      if (this.isLoading) {
        // 如果正在首次加载，显示居中的转圈动画
        Column() {
          LoadingProgress()
            .width(60)
            .height(60)
            .color('#007DFF') // 鸿蒙经典蓝
          Text('努力拉取消息中...')
            .fontSize(14)
            .fontColor('#999999')
            .margin({ top: 10 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)

      } else {
        // 加载完毕后，显示下拉刷新和列表
        // 4. 使用 Refresh 组件包裹 List，实现下拉刷新
        Refresh({ refreshing: $$this.isRefreshing }) {
          List({ space: 0 }) {
            ForEach(this.chatList, (item: MessageItem) => {
              ListItem() {
                MessageListItem({item: item})
              }
            }, (item: MessageItem) => item.id)
          }
          .width('100%')
          .layoutWeight(1)
        }
        .onRefreshing(() => {
          // 5. 当用户下拉时，触发 onRefreshing 事件，重新去服务器拉数据
          this.loadData();
        })
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}