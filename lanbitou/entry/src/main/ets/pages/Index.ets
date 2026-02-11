@Entry
@Component
struct Index {
  build() {
    Column({ space: 12 }) {
      Text('烂笔头').fontSize(22).fontWeight(FontWeight.Bold)
      Text('时间线（占位）')

      Button('新建笔记').onClick(() => {
        // TODO: 跳转到 NoteEditor
      })

      Divider()

      Text('快捷入口')
      Row({ space: 8 }) {
        Button('分类')
        Button('思维导图')
        Button('提醒')
        Button('设置')
      }
    }
    .padding(16)
  }
}
