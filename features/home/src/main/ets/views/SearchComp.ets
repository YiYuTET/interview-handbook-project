import { HdSearch, HdTab, HdTabItem } from '@itcast/basic'
import { InterviewListComp } from '@itcast/interview'
import { router } from '@kit.ArkUI'
import { QuestionListComp } from '../components/QuestionListComp'
import { SearchHistoryComp } from '../components/SearchHistoryComp'
import { historyStore } from '../utils/history'

interface RouterParams {
  type?: number
  questionBankType: 9 | 10
}

@Component
export struct SearchComp {
  @StorageProp('topHeight')
  topHeight: number = 0
  @State
  left: number = 15
  @State
  questionBankType: 9 | 10 = 10
  @State
  isSearching: Boolean = false
  @State
  keyword: string = ''
  // tab
  tabConfig: HdTabItem[] = [
    { name: '试题', value: 10 },
    { name: '面经', value: 9 }
  ]

  aboutToAppear(): void {
    const params = (router.getParams() || {}) as RouterParams
    this.questionBankType = params.questionBankType
  }

  build() {
    Column() {
      Row({ space: 15 }) {
        HdSearch({
          ph: '请输入关键词',
          readonlyMode: false,
          bg: '#f3f4f5',
          val: this.keyword,
          onSubmit: () => {
            if (this.keyword) {
              this.isSearching = true
              historyStore.setItem(this.keyword)
            }
          },
          onChange: (val: string) => {
            this.keyword = val
            if (!val) {
              this.isSearching = false
            }
          }
        })
          .layoutWeight(1)
        Text('取消')
          .fontSize(15)
          .fontColor($r('app.color.black'))
          .onClick(() => router.back())
      }
      .padding({ top: 15, left: 15, right: 15, bottom: 2 })

      HdTab({
        tabConfig: this.tabConfig,
        activeIndex: this.questionBankType === 9 ? 1 : 0,
        onTabClick: (item) => {
          this.questionBankType = item.value as 9 | 10
        }
      })

      if (this.isSearching) {
        if (this.questionBankType === 10) {
          QuestionListComp({
            keyword: encodeURIComponent(this.keyword),
            sort: 0
          })
            .layoutWeight(1)
        }
        if (this.questionBankType === 9) {
          InterviewListComp({
            keyword: encodeURIComponent(this.keyword)
          })
        }
      } else {
        SearchHistoryComp({
          onSearch: (text: string) => {
            this.keyword = text
            this.isSearching = true
          }
        })
      }
    }
    .padding({ top: this.topHeight })
  }
}