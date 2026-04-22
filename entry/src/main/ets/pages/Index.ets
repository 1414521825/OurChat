import { MessagePage } from "../views/MessagePage";

@Entry
@Component
struct Index {
  // 用于记录当前选中的导航栏索引，默认为 0（第一个）
  @State currentIndex: number = 0;

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
      // 如果当前索引等于目标索引，说明被选中，显示蓝色；否则显示灰色
        .fontColor(this.currentIndex == targetIndex ? '#007DFF' : '#999999')
        .fontSize(16)
        .fontWeight(this.currentIndex == targetIndex ? FontWeight.Bold : FontWeight.Normal)
        .margin({top: 5})
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    // 1. 使用 Tabs 组件，并将 barPosition 设置为 End（底部）
    Tabs({barPosition: BarPosition.End}) {
      // 2. 第一个页面内容区（例如：首页）
      TabContent() {
        Column() {
          Text('🏠 首页的内容展示在这里')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F1F3F5') // 给内容区加个浅色背景区分
      }
      .tabBar(this.TabBuilder('首页', 0)) // 绑定底部导航栏按钮
      // 3. 第二个页面内容区（例如：消息）
      TabContent() {
        MessagePage()
      }
      .tabBar(this.TabBuilder('消息', 1)) // 绑定底部导航栏按钮
      // 3. 第二个页面内容区（例如：我的）
      TabContent() {
        Column() {
          Text('👤 我的页面内容展示在这里')
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#E8F5E9')
      }
      .tabBar(this.TabBuilder('我的', 2)) // 绑定底部导航栏按钮
    }
    .onChange((Index: number) => {
      this.currentIndex = Index
    })
    .width('100%')
    .height('100%')
  }
}