import { authStore, HdSearch, HdTab, HdTabItem } from '@itcast/basic'
import { InterviewListComp } from '../components/InterviewListComp'

interface Company {
  icon: ResourceStr
  count: number
}

@Component
export struct InterviewComp {
  @State
  left: number = 16
  @State
  sort: number | undefined = 30
  @StorageProp('topHeight')
  topHeight: number = 0
  // tab
  tabConfig: HdTabItem[] = [
    { name: '推荐', value: 30 },
    { name: '最新', value: undefined }
  ]

  @Builder
  companyBuilder(com: Company) {
    Column({ space: 12 }) {
      Image(com.icon)
        .width(36)
        .aspectRatio(1)
        .margin({ top: 20 })
        .objectFit(ImageFit.Contain)
      Text() {
        Span('热门指数')
        Span(`${com.count}K`)
          .fontColor($r('app.color.common_green'))
      }
      .fontSize(13)
      .fontColor($r('app.color.common_gray_01'))

      Button({ type: ButtonType.Normal }) {
        Text('查看')
          .fontSize(14)
      }
      .backgroundColor($r('app.color.common_gray_bg'))
      .padding(0)
      .height(30)
      .width(80)
      .borderRadius(8)

    }
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
    .height(140)
    .width(100)
  }

  build() {
    Column() {
      Row({ space: 16 }) {
        Image($r('app.media.ic_interview_text'))
          .width(54)
          .height(20)
        HdSearch({ ph: '请输入关键词', bg: $r('app.color.common_gray_bg') })
          .layoutWeight(1)
          .onClick(() => {
            interface Params {
              questionBankType: 9 | 10
            }

            authStore.checkAuth({
              url: 'pages/SearchPage',
              params: ({ questionBankType: 9 }) as Params
            })
          })
      }
      .padding({ left: 16, right: 16 })
      .height(64)
      .margin({ top: this.topHeight })

      // 热门企业
      Scroll() {
        Row({ space: 10 }) {
          this.companyBuilder({ icon: $r('app.media.ic_company_hw'), count: 1.5 })
          this.companyBuilder({ icon: $r('app.media.ic_company_wr'), count: 2.9 })
          this.companyBuilder({ icon: $r('app.media.ic_company_gg'), count: 3.1 })
          this.companyBuilder({ icon: $r('app.media.ic_company_zj'), count: 5.3 })
          this.companyBuilder({ icon: $r('app.media.ic_company_wy'), count: 3.6 })
        }
      }
      .width('100%')
      .height(160)
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .padding(10)

      .edgeEffect(EdgeEffect.Spring)
      .backgroundColor($r('app.color.common_gray_bg'))

      // 标签页
      HdTab({
        tabConfig: this.tabConfig,
        lineWidth: 16,
        onTabChange: (item) => {
          this.sort = item.value as number
        }
      })
      // 文章列表
      InterviewListComp({ sort: this.sort })
    }
    .width('100%')
    .height('100%')
  }
}