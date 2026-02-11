import { listNotes } from '../data/kv'
import router from '@ohos.router'

@Entry
@Component
struct Index {
  @State notes: Array<any> = []

  async aboutToAppear() {
    const context = getContext(this)
    this.notes = await listNotes(context)
  }

  build() {
    Column({ space: 12 }) {
      Text('烂笔头').fontSize(22).fontWeight(FontWeight.Bold)

      Button('新建笔记').onClick(() => {
        router.pushUrl({ url: 'pages/NoteEditor' })
      })

      Divider()

      Text('时间线').fontSize(16).fontWeight(FontWeight.Medium)
      if (this.notes.length === 0) {
        Text('暂无笔记')
      } else {
        ForEach(this.notes, (note: any) => {
          Column({ space: 4 }) {
            Text(note.title || '无标题').fontWeight(FontWeight.Bold)
            Text(note.contentMd || '')
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
            Text(new Date(note.updatedAt).toLocaleString())
              .fontSize(12)
              .fontColor('#888888')
          }
          .padding(8)
          .backgroundColor('#f5f5f5')
          .borderRadius(8)
        })
      }

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
