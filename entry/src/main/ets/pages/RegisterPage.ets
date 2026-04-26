import AuthViewModel from '../viewmodels/AuthViewModel';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
export struct RegisterPage {
  @State username: string = '';
  @State password: string = '';
  @State confirmPassword: string = '';
  @State isLoading: boolean = false;
  onRegisterSuccess?: () => void;
  onGoLogin?: () => void;

  async handleRegister() {
    if (this.isLoading) {
      return;
    }
    this.isLoading = true;

    const result = await AuthViewModel.register(this.username, this.password, this.confirmPassword);
    this.isLoading = false;

    if (result.success) {
      promptAction.showToast({ message: result.message, duration: 2000 });
      this.onRegisterSuccess?.();
    } else {
      promptAction.showToast({ message: result.message, duration: 2000 });
    }
  }

  build() {
    Column() {
      // ========== 顶部标题区 ==========
      Column() {
        Text('创建账号')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#007DFF')
          .margin({ bottom: 8 })

        Text('加入 OurChat，遇见新朋友')
          .fontSize(15)
          .fontColor('#999999')
      }
      .margin({ top: 100, bottom: 56 })

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
          .margin({ bottom: 16 })

        TextInput({ placeholder: '请再次输入密码', text: this.confirmPassword })
          .onChange((value: string) => {
            this.confirmPassword = value;
          })
          .type(InputType.Password)
          .width('100%')
          .height(50)
          .backgroundColor('#F5F5F5')
          .borderRadius(10)
          .padding({ left: 16, right: 16 })
          .margin({ bottom: 36 })

        Button(this.isLoading ? '注册中…' : '注 册')
          .width('100%')
          .height(50)
          .fontSize(17)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .backgroundColor(this.isLoading ? '#99CFFF' : '#007DFF')
          .borderRadius(25)
          .onClick(() => {
            this.handleRegister();
          })
      }
      .width('100%')
      .padding({ left: 32, right: 32 })

      // ========== 底部跳转登录区 ==========
      Row() {
        Text('已有账号？')
          .fontSize(14)
          .fontColor('#999999')
        Text('去登录')
          .fontSize(14)
          .fontColor('#007DFF')
          .onClick(() => {
            this.onGoLogin?.();
          })
      }
      .margin({ top: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
  }
}
