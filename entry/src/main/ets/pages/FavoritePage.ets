import { QuestionItem, ResponseData } from '../models'
import { BasicDataSource } from '../models/BasicDatasource'
import { DIFFICULTY_MAP, EVENT_MAP, PAGE_MAP } from '../constants'
import router from '../utils/router'
import { requestGet } from '../utils/request'
import emitter from '@ohos.events.emitter'
import { LoadingWrapper } from '../components/LoadingWrapper'
import { vp2vp } from '../utils/base'

class QuestionDataSource extends BasicDataSource {
    private questionList: Array<QuestionItem> = []

    public totalCount(): number {
        return this.questionList.length;
    }

    public getData(index: number): QuestionItem {
        return this.questionList[index];
    }

    public reloadData() {
        this.questionList.splice(0, this.questionList.length)
        this.notifyDataReload()
    }

    public addData(index: number, data: QuestionItem): void {
        this.questionList.splice(index, 0, data);
        this.notifyDataAdd(index);
    }

    public updateData(data: Partial<QuestionItem>): void {
        const index = this.questionList.findIndex(item => item.id === data.id)
        if (index > -1) {
            this.questionList.splice(index, 1, { ...this.questionList[index], ...data });
            this.notifyDataChange(index);
        }
    }

    public pushData(data: Array<QuestionItem>): void {
        this.questionList.push(...data);
        this.notifyDataAdd(this.questionList.length - 1);
    }
}

@Entry
@Component
export default struct FavoritePage {
    @State
    loading: boolean = false
    @State
    finished: boolean = false
    // @LocalStorageLink('sharedFavoriteQuestionList')
    @State
    sharedFavoriteQuestionList: Array<QuestionItem> = []
    @State
    total: number = 0
    @State
    pageTotal: number = 0
    @State
    params: {
        optType: number,
        pageSize: number,
        page: number,
        questionBankType: number
    } = {
        optType: 2, //1：点赞，2：收藏
        pageSize: 10,
        page: 1,
        questionBankType: 10,
    }
    questionDataSource = new QuestionDataSource()
    @State
    refreshing: boolean = false

    aboutToAppear() {
        this.initQuestionList()

        emitter.on({ eventId: EVENT_MAP.update_question_list }, (e) => {
            this.questionDataSource.updateData(e.data)
        })
    }

    initQuestionList() {
        this.sharedFavoriteQuestionList = []
        this.loadQuestionList()
    }

    loadQuestionList() {
        if (this.loading || this.finished) return;
        this.loading = true

        requestGet('question/opt/list', this.params)
            .then((res: ResponseData<{
                total: number,
                pageTotal: number
                rows: Array<QuestionItem>
            }>) => {
                // this.questionList.push(...res.data.rows)
                this.questionDataSource.pushData(res.data.rows)
                // 存储 LocalStorage
                this.sharedFavoriteQuestionList.push(...res.data.rows)
                this.total = res.data.total
                this.pageTotal = res.data.pageTotal
                if (this.params.page >= this.pageTotal) {
                    this.finished = true
                } else {
                    this.params.page++
                }
                this.loading = false
            })
    }


    build() {
        Navigation() {

            Refresh({ refreshing: $$this.refreshing, offset: 0, friction: 60 }) {
                List() {
                    LazyForEach(this.questionDataSource, (item: QuestionItem) => {
                        ListItem() {
                            Column() {
                                Row() {
                                    Text(DIFFICULTY_MAP[item.difficulty]?.text)
                                        .fontColor(DIFFICULTY_MAP[item.difficulty]?.color)
                                        .fontSize(vp2vp(10))
                                        .width(vp2vp(34))
                                        .height(vp2vp(18))
                                        .backgroundColor($r('app.color.ih_bg_color'))
                                        .borderRadius(vp2vp(2))
                                        .textAlign(TextAlign.Center)
                                        .margin({ right: vp2vp(7) })
                                    Text(item.stem)
                                        .fontSize(vp2vp(16))
                                        .layoutWeight(1)
                                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                                        .maxLines(1)
                                }.width('100%')

                                Row() {
                                    Text(`点赞 ${item.likeCount}`).fontColor('#C3C3C5').fontSize(vp2vp(13))
                                    Text('|')
                                        .width(vp2vp(30))
                                        .textAlign(TextAlign.Center)
                                        .fontColor('#C3C3C5')
                                        .fontSize(vp2vp(13))
                                    Text(`浏览 ${item.views}`).fontColor('#C3C3C5').fontSize(vp2vp(13))
                                    if (item.readFlag === 1) {
                                        Text('|')
                                            .width(vp2vp(30))
                                            .textAlign(TextAlign.Center)
                                            .fontColor('#C3C3C5')
                                            .fontSize(vp2vp(13))
                                        Text(`已看过`).fontColor('#C3C3C5').fontSize(vp2vp(13))
                                    }
                                }
                                .width('100%')
                                .margin({ top: vp2vp(10) })
                            }.onClick(() => {
                                router.push({
                                    url: 'pages/FavoriteQuestionDetailPage',
                                    params: {
                                        id: item.id,
                                        stem: item.stem,
                                        sharedFavoriteQuestionList: this.sharedFavoriteQuestionList
                                    }
                                })
                            })
                        }
                        .height(vp2vp(80))
                        .width('100%')
                    }, ({id,likeCount,readFlag}) => JSON.stringify({ id, likeCount, readFlag }))
                    ListItem() {
                        LoadingWrapper({
                            loading: this.loading,
                            finished: this.finished
                        })
                    }
                }
                .divider({
                    strokeWidth: 0.5,
                    color: $r('app.color.ih_bg_color')
                })
                .padding({ left: vp2vp(15), right: vp2vp(15) })
                .height('100%')
                .width('100%')
                .onReachEnd(() => {
                    this.loadQuestionList()
                })
            }
            .onRefreshing(() => {
                setTimeout(() => {
                    this.refreshing = false
                }, 1000)
            })
        }
        .mode(NavigationMode.Stack)
        .title('我的收藏')
        .titleMode(NavigationTitleMode.Mini)
    }
}