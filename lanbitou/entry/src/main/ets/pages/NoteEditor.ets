import { saveNote, findOrCreateCategory, findOrCreateTags } from '../data/kv'
import router from '@ohos.router'

@Entry
@Component
struct NoteEditor {
  @State title: string = ''
  @State content: string = ''
  @State categoryName: string = ''
  @State tags: string = '' // comma separated

  build() {
    Column({ space: 12 }) {
      Text('编辑笔记').fontSize(20).fontWeight(FontWeight.Bold)

      TextInput({ text: this.title, placeholder: '标题' })
        .onChange(v => this.title = v)

      TextInput({ text: this.categoryName, placeholder: '分类（可输入新分类）' })
        .onChange(v => this.categoryName = v)

      TextInput({ text: this.tags, placeholder: '标签（逗号分隔）' })
        .onChange(v => this.tags = v)

      TextArea({ text: this.content, placeholder: '输入内容（富文本后续完善）' })
        .height(260)
        .onChange(v => this.content = v)

      Row({ space: 8 }) {
        Button('保存').onClick(async () => {
          const now = Date.now()
          const context = getContext(this)
          const cat = await findOrCreateCategory(context, this.categoryName)
          const tagIds = await findOrCreateTags(context, this.tags.split(','))
          const note = {
            id: now.toString(),
            title: this.title,
            contentMd: this.content,
            createdAt: now,
            updatedAt: now,
            categoryId: cat?.id,
            tagIds
          }
          await saveNote(context, note)
          router.back()
        })
        Button('取消').onClick(() => router.back())
      }
    }
    .padding(16)
  }
}
