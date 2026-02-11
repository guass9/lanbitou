@Entry
@Component
struct Reminder {
  build() {
    Column({ space: 12 }) {
      Text('提醒设置').fontSize(20).fontWeight(FontWeight.Bold)
      Text('提醒规则设置占位')
    }
    .padding(16)
  }
}
