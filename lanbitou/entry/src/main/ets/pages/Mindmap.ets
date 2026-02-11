@Entry
@Component
struct Mindmap {
  build() {
    Column({ space: 12 }) {
      Text('思维导图').fontSize(20).fontWeight(FontWeight.Bold)
      Text('轻量思维导图占位')
    }
    .padding(16)
  }
}
