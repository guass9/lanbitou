@Entry
@Component
struct Settings {
  build() {
    Column({ space: 12 }) {
      Text('设置').fontSize(20).fontWeight(FontWeight.Bold)
      Text('深色模式 / 加密 / 通知设置')
    }
    .padding(16)
  }
}
