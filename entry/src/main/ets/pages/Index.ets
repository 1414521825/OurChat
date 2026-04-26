import { MessagePage } from "../views/MessagePage";
import { ProfilePage } from "../views/ProfilePage";
import { ChatDetail } from "./ChatDetail";
import { LoginPage } from "./LoginPage";
import { RegisterPage } from "./RegisterPage";
import { TokenManager } from "../utils/TokenManager";

@Entry
@Component
struct Index {
  // 用于记录当前选中的导航栏索引，默认为 0（第一个）
  @State currentIndex: number = 0;
  // 🌟 登录状态控制
  @State isLoggedIn: boolean = false;
  @State isChecking: boolean = true;
  // 控制显示登录页还是注册页
  @State showRegister: boolean = false;
  private tabsController: TabsController = new TabsController();
  // 🌟 核心 1：初始化路由栈
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();
  // 🌟 核心 2：配置路由映射表
  @Builder
  PageMap(name: string, param: object) {
    if (name === 'ChatDetail') {
      ChatDetail();
    }
  }

  async aboutToAppear() {
    // APP 启动时检查本地是否存有 token，决定跳过登录还是进入登录页
    this.isLoggedIn = await TokenManager.isLoggedIn();
    this.isChecking = false;
  }

  @Builder
  TabBuilder(title: string, targetIndex: number) {
    Column() {
      Text(title)
        .fontColor(this.currentIndex == targetIndex ? '#007DFF' : '#999999')
        .fontSize(16)
        .fontWeight(this.currentIndex == targetIndex ? FontWeight.Bold : FontWeight.Normal)
        .margin({ top: 5 })
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  build() {
    // ========== 1. 正在检查登录状态，显示加载动画 ==========
    if (this.isChecking) {
      Column() {
        LoadingProgress()
          .width(48)
          .height(48)
          .color('#007DFF')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .backgroundColor('#FFFFFF')
    }
    // ========== 2. 未登录，根据 showRegister 切换登录/注册页 ==========
    else if (!this.isLoggedIn) {
      if (this.showRegister) {
        RegisterPage({
          onRegisterSuccess: () => {
            this.isLoggedIn = true;
          },
          onGoLogin: () => {
            this.showRegister = false;
          }
        })
      } else {
        LoginPage({
          onLoginSuccess: () => {
            this.isLoggedIn = true;
          },
          onGoRegister: () => {
            this.showRegister = true;
          }
        })
      }
    }
    // ========== 3. 已登录，显示主界面 ==========
    else {
      Navigation(this.pageStack) {
        Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
          TabContent() {
            Column() {
              Text('🏠 首页的内容展示在这里')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
            }
            .width('100%')
            .height('100%')
            .justifyContent(FlexAlign.Center)
            .backgroundColor('#F1F3F5')
          }
          .tabBar(this.TabBuilder('首页', 0))

          TabContent() {
            MessagePage()
          }
          .tabBar(this.TabBuilder('消息', 1))

          TabContent() {
            ProfilePage()
          }
          .tabBar(this.TabBuilder('我的', 2))
        }
        .onChange((Index: number) => {
          this.currentIndex = Index;
        })
        .width('100%')
        .height('100%')
      }
      .hideTitleBar(true)
      .navDestination(this.PageMap)
      .mode(NavigationMode.Stack)
    }
  }
}