import { hdHttp, HdList, HdListController, HdNav, HdTab, HdTabItem } from '@itcast/basic'
import { QuestionItem, QuestionItemComp } from '@itcast/home'
import { InterviewItem, InterviewItemComp } from '@itcast/interview'
import { router } from '@kit.ArkUI'

export enum OptionalType {
  LIKE = 1,
  COLLECT = 2,
  HISTORY = 3
}

export interface OptionalRouterParams {
  type: OptionalType
}

export enum ContentType {
  INTERVIEW = 9,
  QUESTION = 10
}

export interface OptionalRequestParams {
  optType: OptionalType
  page: number
  questionBankType: ContentType
}

export interface OptionalResponseData {
  total: number
  pageTotal: number
  rows: (InterviewItem | QuestionItem)[]
}

@Component
export struct OptionalComp {
  @State
  title: string = ''
  @State
  requestParams: OptionalRequestParams = {
    optType: OptionalType.LIKE,
    page: 1,
    questionBankType: ContentType.QUESTION
  }
  @State
  list: (InterviewItem | QuestionItem)[] = []
  controller = new HdListController()
  timer: number = 0

  aboutToAppear(): void {
    const params = router.getParams() as OptionalRouterParams
    this.requestParams.optType = params.type
    switch (params?.type) {
      case OptionalType.LIKE:
        this.title = '我的点赞';
        break;
      case OptionalType.COLLECT:
        this.title = '我的收藏';
        break;
      case OptionalType.HISTORY:
        this.title = '浏览历史';
        break;
    }
  }

  tabConfig: HdTabItem[] = [
    { name: '试题', value: ContentType.QUESTION },
    { name: '面经', value: ContentType.INTERVIEW }
  ]

  onUpdate() {
    if (this.timer) clearTimeout(this.timer)
    this.list = []
    this.controller.reload()
    this.timer = setTimeout(() => {
      this.onRefresh()
    }, 500)
  }

  onLoad() {
    hdHttp.get<OptionalResponseData>('question/opt/list', this.requestParams).then(res => {
      this.list.push(...res.data.rows)
      this.controller.loaded()
      if (this.requestParams.page >= res.data.pageTotal) {
        this.controller.finished()
      } else {
        this.requestParams.page++
      }
    })
  }

  onRefresh() {
    this.requestParams.page = 1
    hdHttp.get<OptionalResponseData>('question/opt/list', this.requestParams).then(res => {
      this.list.push(...res.data.rows)
      this.controller.loaded()
      this.list = res.data.rows
      this.controller.refreshed()
      if (this.requestParams.page >= res.data.pageTotal) {
        this.controller.finished()
      } else {
        this.requestParams.page++
      }
    })
  }

  build() {
    Column() {
      HdNav({ title: this.title, showRightIcon: false })
      HdTab({
        tabConfig: this.tabConfig,
        onTabChange: (item: HdTabItem) => {
          this.requestParams.questionBankType = item.value as ContentType
          this.onUpdate()
        }
      })
      HdList({
        lw: 1,
        controller: this.controller,
        onRefresh: () => {
          this.onUpdate()
        },
        onLoad: () => {
          this.onLoad()
        }
      }) {
        ForEach(this.list, (item: InterviewItem | QuestionItem) => {
          ListItem() {
            if (this.requestParams.questionBankType === ContentType.INTERVIEW) {
              InterviewItemComp({ item: item as InterviewItem })
            } else if (this.requestParams.questionBankType === ContentType.QUESTION) {
              QuestionItemComp({ item: item as QuestionItem })
            }
          }
        })
      }
    }
    .width('100%')
    .height('100%')

  }
}