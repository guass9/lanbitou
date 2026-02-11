import { saveNote } from '../data/kv'
import router from '@ohos.router'

@Entry
@Component
struct NoteEditor {
  @State title: string = ''
  @State content: string = ''

  build() {
    Column({ space: 12 }) {
      Text('编辑笔记').fontSize(20).fontWeight(FontWeight.Bold)

      TextInput({ text: this.title, placeholder: '标题' })
        .onChange(v => this.title = v)

      TextArea({ text: this.content, placeholder: '输入内容（富文本后续完善）' })
        .height(300)
        .onChange(v => this.content = v)

      Row({ space: 8 }) {
        Button('保存').onClick(async () => {
          const now = Date.now()
          const note = {
            id: now.toString(),
            title: this.title,
            contentMd: this.content,
            createdAt: now,
            updatedAt: now
          }
          const context = getContext(this)
          await saveNote(context, note)
          router.back()
        })
        Button('取消').onClick(() => router.back())
      }
    }
    .padding(16)
  }
}
