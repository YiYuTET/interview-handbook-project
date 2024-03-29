export interface HdTabItem {
  name: string
  value?: string | number
}

@Component
export struct HdTab {
  @Prop
  activeIndex: number = 0
  @Prop
  tabConfig: HdTabItem[] = []
  @State
  left: number = 0
  @Prop
  lineWidth: number = 20
  @Prop
  gutter: number = 20
  // cb
  onTabClick?: (tab: HdTabItem, index: number) => void
  onTabChange?: (tab: HdTabItem, index: number) => void

  // 设置线位置
  setLineLeft(area: Area) {
    const width = area.width as number
    const x = area.position.x as number
    this.left = x + (width - this.lineWidth) / 2
  }

  @Builder
  TabBuilder(tab: HdTabItem, index: number) {
    Text(tab.name)
      .fontSize(15)
      .fontColor(this.activeIndex === index ? $r('app.color.black') : '#979797')
      .animation({
        duration: 300
      })
      .onClick((e) => {
        if (this.activeIndex !== index) {
          this.setLineLeft(e.target.area)
          this.activeIndex = index
          this.onTabChange && this.onTabChange(tab, index)
        }
        this.onTabClick && this.onTabClick(tab, index)
      })
      .onAreaChange((_o, n) => {
        if (this.activeIndex === index) {
          this.setLineLeft(n)
        }
      })
  }

  build() {
    Row() {
      Row({ space: this.gutter }) {
        ForEach(this.tabConfig, (item: HdTabItem, index) => {
          this.TabBuilder(item, index)
        })
      }
      .width('100%')
      .padding({ left: this.gutter, right: this.gutter })
      .height(40)
      .border({
        width: { bottom: $r('app.float.common_border_width') },
        color: $r('app.color.common_gray_border')
      })

      Text()
        .width(this.lineWidth)
        .height(2)
        .backgroundColor($r('app.color.black'))
        .position({ x: this.left, y: 38 })
        .animation({
          duration: 300
        })
    }
  }
}