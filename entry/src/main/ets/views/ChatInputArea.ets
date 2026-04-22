@Component
export struct ChatInputArea {
  @Link inputText: string;
  @Prop isSending: boolean;

  onSend: () => void = () => {}

  build() {
    Row() {
      // 左侧：语音
      Text('🎤').fontSize(24).margin({ right: 10 })

      // 中间：输入框
      TextInput({ text: this.inputText, placeholder: '说点什么...' })
        .layoutWeight(1)
        .height(40)
        .backgroundColor('#F1F3F5')
        .borderRadius(20)
        .onSubmit(() => {
          this.onSend();
        })
        .onChange((value: string) => {
          this.inputText = value;
        })

      // 右侧：动态切换（图片 =》发送）
      Row() {
        if (this.inputText.length > 0) {
          Button(this.isSending ? '...' : '发送')
            .height(32)
            .fontSize(14)
            .backgroundColor('#007DFF')
            .onClick(() => {
              this.onSend();
            })
        } else {
          Text('⊕')
            .fontSize(28)
            .fontColor('#666666')
            .onClick(() => {
              console.info('打开功能面板');
            })
        }
      }
      .width(60)
      .margin({ left: 10 })
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .padding({ left: 15, right: 15, top: 10, bottom: 10 })
    .backgroundColor('#F8F8F8')
  }
}