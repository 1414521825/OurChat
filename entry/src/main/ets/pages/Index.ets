import { MessagePage } from "../views/MessagePage";
import { PromptAction } from "@kit.ArkUI";

@Entry
@Component
struct Index {
  // 用于记录当前选中的导航栏索引，默认为 0（第一个）
  @State currentIndex: number = 0;
  private tabsController: TabsController = new TabsController();
  private lastBackPressTime: number = 0;
  private promptAction: PromptAction = new PromptAction();

  onBackPress(): boolean | void {
    let currentTime = Date.now();
    // 判断距离上次点击是否超过了 2 秒（2000毫秒）
    let isTimeout = (currentTime - this.lastBackPressTime) > 2000;

    if (this.currentIndex != 0) {
      this.currentIndex = 0;
      this.tabsController.changeIndex(0);
      // 提示并记录时间
      this.promptAction
        .showToast({ message: '再按一次退出应用', duration: 2000, bottom: 80 });
      this.lastBackPressTime = currentTime;
      return true;
    }
    else {
      if (isTimeout) {
        // 第一次按下，或者距离上次按下超过了 2 秒
        // 👉 在这里触发首页的刷新逻辑！
        // 实际开发中，你可以调用 ViewModel 去重新拉取网络数据
        console.info('执行首页刷新逻辑：拉取最新推荐列表...');
        // 提示并记录时间
        this.promptAction
          .showToast({ message: '再按一次退出应用', duration: 2000, bottom: 80 });
        this.lastBackPressTime = currentTime;
        return true;
      }
      else {
        // 2秒内连续按了第二次
        return false; // 🚦 放行！系统会执行默认的退出应用逻辑
      }
    }
  }

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
    Tabs({barPosition: BarPosition.End, controller: this.tabsController}) {
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