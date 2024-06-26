import { hdHttp, HdLoadingDialog, HdNav, HdTag, HdWeb } from '@itcast/basic/Index'
import { InterviewItem, InterviewItemModel, InterviewRelatedQuestion } from '../models/InterviewItemModel'
import { webview } from '@kit.ArkWeb'
import { promptAction, router } from '@kit.ArkUI'

export interface OptPrams {
  id: string,
  type: number,
  optType: 1 | 2
}

@Component
export struct InterviewDetailComp {
  @State
  show: boolean = false
  @State
  item: InterviewItemModel = new InterviewItemModel({} as InterviewItem)
  scroller: Scroller = new Scroller()
  dialog: CustomDialogController = new CustomDialogController({
    builder: HdLoadingDialog({ message: '加载中...' }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  webController: webview.WebviewController = new webview.WebviewController()

  aboutToAppear(): void {
    this.dialog.open()
    const params = (router.getParams() || {}) as InterviewItem
    this.item = new InterviewItemModel(params)
    this.item.content = ''
    hdHttp.get<InterviewItem>(`question/${params.id}`).then(res => {
      this.item = new InterviewItemModel(res.data)
      this.webController.runJavaScript(`writeContent(\`${res.data.content || ''}\`)`)
      this.dialog.close()
    }).catch(() => {
      this.dialog.close()
    })
  }

  /**
   * 操作:点赞、收藏
   * @param type = 1 | 2
   */
  async opt(optType: 1 | 2, flag: 0 | 1) {
    try {
      let data: OptPrams = {
        id: this.item.id,
        type: 1,
        optType
      }
      await hdHttp.post<null>(flag === 1 ? 'question/opt' : 'question/unOpt', data)
      if (optType === 1) {
        this.item.likeFlag = flag
        return promptAction.showToast({ message: flag === 1 ? '点赞成功' : '取消点赞' })
      }
      if (optType === 2) {
        this.item.collectFlag = flag
        return promptAction.showToast({ message: flag === 1 ? '收藏成功' : '取消收藏' })
      }
    } catch (err) {
      promptAction.showToast({ message: '操作失败' })
    }
  }

  @Builder
  menuBuilder() {
    Menu() {
      MenuItem({ content: this.item?.likeFlag === 1 ? '取消点赞' : '点赞' })
        .onClick(() => {
          this.opt(1, this.item.likeFlag === 1 ? 0 : 1)
        })
      MenuItem({ content: this.item?.collectFlag === 1 ? '取消收藏' : '收藏' })
        .onClick(() => {
          this.opt(2, this.item.collectFlag === 1 ? 0 : 1)
        })
      MenuItem({ content: '分享' })
    }
    .width(108)
  }

  build() {
    Column() {
      HdNav({
        title: this.show ? this.item.stem : '',
        menuBuilder: () => {
          this.menuBuilder()
        }
      })

      Column() {
        Scroll(this.scroller) {
          Column({ space: 16 }) {
            Text(this.item.stem)
              .fontWeight(600)
              .fontSize(18)
              .padding({ left: 15, right: 15 })

            Row({ space: 4 }) {
              Image(this.item.creatorAvatar)
                .width(36)
                .aspectRatio(1)
              Column({ space: 4 }) {
                Text(this.item.creatorName)
                  .fontSize(14)
                Text() {
                  Span('浏览 ' + this.item.views)
                  Span(' · ')
                  Span('点赞 ' + this.item.likeCount)
                  Span(' · ')
                  Span(this.item.createdAt)
                }
                .width('100%')
                .fontSize($r('app.float.common_font12'))
                .fontColor('#bdbdbd')
              }
              .alignItems(HorizontalAlign.Start)
              .layoutWeight(1)
            }
            .padding({ left: 15, right: 15 })

            Row({ space: 4 }) {
              ForEach(['大厂', '面经'], (tag: string) => {
                HdTag({ text: tag })
              })
            }
            .width('100%')
            .padding({ left: 15, right: 15 })

            HdWeb({
              layoutMode: WebLayoutMode.FIT_CONTENT,
              controller: this.webController, onLoad: () => {
                this.webController.runJavaScript(`writeContent(\`${this.item.content || ''}\`)`)
              }
            })
            // ref
            if (this.item.relatedQuestions && this.item.relatedQuestions.length) {
              Row({ space: 4 }) {
                Text('相关题目：')
                  .fontSize(14)
                Column({ space: 10 }) {
                  ForEach(this.item.relatedQuestions, (item: InterviewRelatedQuestion) => {
                    Row() {
                      Image($r('app.media.ic_interview_file'))
                        .size({ width: 14, height: 14 })
                        .fillColor($r('app.color.common_blue'))
                      Text(` ${item.stem.replace(/<[^>]*>/g, '')}`)
                        .fontSize(12)
                        .fontColor($r('app.color.common_blue'))
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .width('100%')
                  })
                }
                .layoutWeight(1)
              }
              .alignItems(VerticalAlign.Top)
              .padding(15)
              .backgroundColor($r('app.color.common_gray_bg'))
              .borderRadius(8)
              .margin({ left: 15, right: 15 })
            }

            Text('© 著作权归作者所有')
              .fontSize(12)
              .fontColor($r('app.color.common_gray_01'))
              .height(20)
          }
        }
        .onScroll(() => {
          this.show = this.scroller.currentOffset().yOffset > 30
        })
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}