@Entry
@Component
struct NoteEditor {
  @State content: string = ''

  build() {
    Column({ space: 12 }) {
      Text('编辑笔记').fontSize(20).fontWeight(FontWeight.Bold)
      TextArea({ text: this.content, placeholder: '输入内容（富文本后续完善）' })
        .height(300)
        .onChange(v => this.content = v)
      Button('保存').onClick(() => {
        // TODO: 保存到KV
      })
    }
    .padding(16)
  }
}
