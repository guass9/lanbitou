import { listCategories, listTags } from '../data/kv'

@Entry
@Component
struct Categories {
  @State cats: Array<any> = []
  @State tags: Array<any> = []

  async aboutToAppear() {
    const context = getContext(this)
    this.cats = await listCategories(context)
    this.tags = await listTags(context)
  }

  build() {
    Column({ space: 12 }) {
      Text('分类').fontSize(20).fontWeight(FontWeight.Bold)
      if (this.cats.length === 0) {
        Text('暂无分类')
      } else {
        ForEach(this.cats, (c: any) => {
          Text(c.name)
        })
      }

      Divider()

      Text('标签').fontSize(20).fontWeight(FontWeight.Bold)
      if (this.tags.length === 0) {
        Text('暂无标签')
      } else {
        ForEach(this.tags, (t: any) => {
          Text(t.name)
        })
      }
    }
    .padding(16)
  }
}
