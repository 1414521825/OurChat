import { UserProfile } from '../models/ProfileModel';
import ProfileViewModel from '../viewmodels/ProfileViewModel';
import { PromptAction } from "@kit.ArkUI";
import AuthViewModel from "../viewmodels/AuthViewModel";

// 菜单列表项子组件
@Component
struct MenuListItem {
  private icon: string = '';
  private title: string = '';
  private iconBgColor: string = '#E8F5E9';
  private promptAction: PromptAction = new PromptAction();

  build() {
    Row() {
      // 彩色圆形图标背景
      Stack() {
        Circle({ width: 32, height: 32 }).fill(this.iconBgColor)
        Text(this.icon).fontSize(16)
      }
      .width(32)
      .height(32)
      .margin({ right: 12 })

      // 标题
      Text(this.title).fontSize(16).fontColor('#1A1A1A')
      // 弹性空间
      Blank()
      // 右侧箭头
      Text('›').fontSize(22).fontColor('#D0D0D0')
    }
    .width('100%')
    .height(52)
    .padding({ left: 16, right: 16 })
    .onClick(() => {
      this.promptAction.showToast({ message: '功能开发中', duration: 1500 });
    })
  }
}

@Component
export struct ProfilePage {
  @State profile: UserProfile = new UserProfile('', '', '');
  @State isLoading: boolean = true;
  private promptAction: PromptAction = new PromptAction();
  // 添加回调，方便通知首页，用户已经登出
  onLogoutSuccess?: () => void;

  aboutToAppear() {
    this.loadProfile();
  }

  async loadProfile() {
    let data = await ProfileViewModel.getMyProfile();
    this.profile = data;
    this.isLoading = false;
  }

  build() {
    Column() {
      if (this.isLoading) {
        // ----- 加载态 -----
        Column() {
          LoadingProgress().width(40).height(40).color('#007DFF')
          Text('加载中...').fontSize(14).fontColor('#999999').margin({ top: 12 })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
      } else {
        Scroll() {
          Column() {
            // ============================================================
            // 1. 个人资料卡片（渐变背景 + 头像重叠 + 昵称签名）
            // ============================================================
            Column() {
              // 渐变色背景条
              Column()
                .width('100%')
                .height(100)
                .linearGradient({
                  direction: GradientDirection.Bottom,
                  colors: [['#007DFF', 0], ['#00A3FF', 1]]
                })

              // 头像（用白色圆环包裹，向上重叠渐变区）
              Stack() {
                Circle({ width: 80, height: 80 }).fill(Color.White)
                Circle({ width: 74, height: 74 }).fill('#007DFF')
                Text(this.profile.name.charAt(0))
                  .fontSize(30)
                  .fontColor(Color.White)
                  .fontWeight(FontWeight.Bold)
              }
              .margin({ top: -40 })

              // 昵称
              Text(this.profile.name)
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor('#1A1A1A')
                .margin({ top: 12 })

              // 个性签名（可点击编辑）
              Row() {
                Text(this.profile.bio)
                  .fontSize(14)
                  .fontColor('#999999')
                Text(' 编辑')
                  .fontSize(13)
                  .fontColor('#007DFF')
              }
              .margin({ top: 6, bottom: 28 })
              .onClick(() => {
                this.promptAction.showToast({ message: '编辑个人资料功能开发中', duration: 1500 });
              })
            }
            .width('100%')
            .backgroundColor(Color.White)

            // ============================================================
            // 2. 功能菜单（圆角卡片）
            // ============================================================
            Column() {
              Column() {
                MenuListItem({
                  icon: '📷',
                  title: '我的相册',
                  iconBgColor: '#E8F5E9'
                })
                // 缩进分隔线（避开头像区域）
                Row()
                  .height(1)
                  .width('100%')
                  .backgroundColor('#F0F0F0')
                  .margin({ left: 60 })

                MenuListItem({
                  icon: '⭐',
                  title: '我的收藏',
                  iconBgColor: '#FFF8E1'
                })
                Row()
                  .height(1)
                  .width('100%')
                  .backgroundColor('#F0F0F0')
                  .margin({ left: 60 })

                MenuListItem({
                  icon: '⚙️',
                  title: '设置',
                  iconBgColor: '#E3F2FD'
                })
              }
              .width('100%')
              .backgroundColor(Color.White)
              .borderRadius(12)
              .padding({ top: 8, bottom: 8 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 20 })

            // ============================================================
            // 3. 退出登录按钮（圆角白底红字）
            // ============================================================
            Button('退出登录')
              .width('100%')
              .height(48)
              .backgroundColor(Color.White)
              .fontColor('#FF3B30')
              .fontSize(16)
              .borderRadius(12)
              .margin({ top: 24, left: 16, right: 16 })
              .onClick(async () => {
                const result = await AuthViewModel.logout();
                this.promptAction.showToast({ message: result.message, duration: 2000 });
                this.onLogoutSuccess?.();
              })

            // 底部留白
            Column().height(40).width('100%')
          }
          .width('100%')
        }
        .width('100%')
        .layoutWeight(1)
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F2F4F7')
  }
}
