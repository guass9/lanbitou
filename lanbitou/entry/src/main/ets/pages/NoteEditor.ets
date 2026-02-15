import { saveNote, findOrCreateCategory, findOrCreateTags, NoteItem } from '../data/kv'
import router from '@ohos.router'

@Entry
@Component
struct NoteEditor {
  @State title: string = ''
  @State content: string = ''
  @State categoryName: string = ''
  @State tags: string = ''

  build() {
    Column({ space: 12 }) {
      Text('编辑笔记').fontSize(20).fontWeight(FontWeight.Bold)

      TextInput({ text: this.title, placeholder: '标题' })
        .onChange((v: string) => this.title = v)

      TextInput({ text: this.categoryName, placeholder: '分类（可输入新分类）' })
        .onChange((v: string) => this.categoryName = v)

      TextInput({ text: this.tags, placeholder: '标签（逗号分隔）' })
        .onChange((v: string) => this.tags = v)

      TextArea({ text: this.content, placeholder: '输入内容' })
        .height(260)
        .onChange((v: string) => this.content = v)

      Row({ space: 8 }) {
        Button('保存').onClick(async () => {
          const now: number = Date.now()
          const context = getContext(this)
          const cat = await findOrCreateCategory(context, this.categoryName)
          const tagIds: string[] = await findOrCreateTags(context, this.tags.split(','))

          const note: NoteItem = {
            id: now.toString(),
            title: this.title,
            contentMd: this.content,
            updatedAt: now,
            categoryId: cat ? cat.id : undefined,
            tagIds: tagIds
          }

          await saveNote(context, note)
          router.back()
        })

        Button('取消').onClick(() => {
          router.back()
        })
      }
    }
    .padding(16)
  }
}