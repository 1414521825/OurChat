import AuthViewModel from '../viewmodels/AuthViewModel';
import { promptAction } from '@kit.ArkUI';

@Component
export struct LoginPage {
  // 表单状态：用户名、密码、加载中
  @State username: string = '';
  @State password: string = '';
  @State isLoading: boolean = false;
  // 登录成功后回调，通知父组件切换页面
  onLoginSuccess?: () => void;
  // 点击「去注册」时回调
  onGoRegister?: () => void;

  async handleLogin() {
    // 防止重复点击
    if (this.isLoading) {

      return;
    }
    this.isLoading = true;

    const result = await AuthViewModel.login(this.username, this.password);
    this.isLoading = false;

    if (result.success) {
      promptAction.showToast({ message: result.message, duration: 2000 });
      // 通知 Index 登录成功，切换到主界面
      this.onLoginSuccess?.();
    } else {
      promptAction.showToast({ message: result.message, duration: 2000 });
    }
  }

  build() {
    Column() {
      // ========== 顶部标题区 ==========
      Column() {
        Text('OurChat')
          .fontSize(36)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007DFF')
          .margin({ bottom: 8 })

        Text('遇见你的那个TA')
          .fontSize(15)
          .fontColor('#999999')
      }
      .margin({ top: 120, bottom: 64 })

      // ========== 中间表单区 ==========
      Column() {
        TextInput({ placeholder: '请输入用户名', text: this.username })
          .onChange((value: string) => {
            this.username = value;
          })
          .width('100%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .padding({ left: 16, right: 16 })
          .margin({ bottom: 16 })

        TextInput({ placeholder: '请输入密码', text: this.password })
          .onChange((value: string) => {
            this.password = value;
          })
          .type(InputType.Password)
          .width('100%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .padding({ left: 16, right: 16 })
          .margin({ bottom: 36 })

        Button(this.isLoading ? '登录中…' : '登 录')
          .width('100%')
          .height(50)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(this.isLoading ? '#99CFFF' : '#007DFF')
          .borderRadius(25)
          .onClick(() => {
            this.handleLogin();
          })
      }
      .width('100%')
      .padding({ left: 32, right: 32 })

      // ========== 底部跳转注册区 ==========
      Row() {
        Text('没有账号？')
          .fontSize(14)
          .fontColor('#999999')
        Text('去注册')
          .fontSize(14)
          .fontColor('#007DFF')
          .onClick(() => {
            this.onGoRegister?.();
          })
      }
      .margin({ top: 32 })

      // TODO: 后端登录 API 就绪后删掉这行
      Text('开发登录 (跳过API)')
        .fontSize(13)
        .fontColor('#CCCCCC')
        .margin({ top: 24 })
        .onClick(async () => {
          if (this.isLoading) return;
          this.isLoading = true;
          const result = await AuthViewModel.loginDev();
          this.isLoading = false;
          if (result.success) {
            promptAction.showToast({ message: result.message, duration: 2000 });
            this.onLoginSuccess?.();
          }
        })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
