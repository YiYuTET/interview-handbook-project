import promptAction from '@ohos.promptAction'
import { vp2vp } from '../utils/base'
@Component
struct questionnaire{
    number : string = '01'
    message:string = '您对面试宝典App的满意程度?'
    singleChoice : boolean = true
    group : string = 'group1'
    @Prop
    isPush : boolean
    build(){
        Column(){
            Row(){
                Text(this.number)
                    .fontSize(vp2vp(18))
                    .fontWeight(FontWeight.Medium)
                    // .margin({right : vp2vp(5)})

                Text(this.message)
                    .fontSize(vp2vp(18))
                    .fontWeight(FontWeight.Bold)

                Text(this.singleChoice ? '单选' : '多选')
                    .fontSize(vp2vp(18))
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#2981F8')
                    // .margin({left : vp2vp(18)})
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)

            Row(){
                Radio({ value: 'Radio1', group: this.group })
                    .checked(this.isPush)
                Text('十分满意')
                Radio({ value: 'Radio2', group: this.group })
                    .checked(this.isPush)
                Text('满意')
                Radio({ value: 'Radio3', group: this.group })
                    .checked(this.isPush)
                Text('一般')
                Radio({ value: 'Radio4', group: this.group })
                    .checked(this.isPush)
                Text('不满意')
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.SpaceBetween)
    }
}

@Entry
@Component
struct SurveyPage {

    @State
    isPush : boolean = false
    build() {
        Navigation() {
            Column(){
                Column(){
                    questionnaire({number : '01', message : '您对面试宝典App的满意程度?', singleChoice : true, group : 'group1', isPush : this.isPush})
                        .width('90%')
                        .height(60)
                        .backgroundColor('#fff')
                        .margin({top : vp2vp(20)})


                    questionnaire({number : '02', message : '您对面经分享的满意程度?', singleChoice : true, group : 'group2', isPush : this.isPush})
                        .width('90%')
                        .height(60)
                        .backgroundColor('#fff')
                        .margin({top : vp2vp(20)})

                    questionnaire({number : '03', message : '您对打卡的满意程度?', singleChoice : true, group : 'group3', isPush : this.isPush})
                        .width('90%')
                        .height(60)
                        .backgroundColor('#fff')
                        .margin({top : vp2vp(20)})

                    questionnaire({number : '04', message : '您对面试题列表的满意程度?', singleChoice : true, group : 'group4', isPush : this.isPush})
                        .width('90%')
                        .height(60)
                        .backgroundColor('#fff')
                        .margin({top : vp2vp(20)})


                    Column(){
                        Row(){
                            Text('05')
                                .fontSize(vp2vp(18))
                                .fontWeight(FontWeight.Medium)
                                .margin({right : vp2vp(20)})

                            Text('您对我们有什么建议?')
                                .fontSize(vp2vp(18))
                                .fontWeight(FontWeight.Bold)

                        }
                        .width('100%')
                        .height(30)
                        // .justifyContent(FlexAlign.Start)

                        TextArea()
                            .width('90%')
                            .height(200)
                            .backgroundColor('#F1F1F1')
                    }
                    .width('90%')
                    .height('35%')
                    .margin({top : vp2vp(20)})
                    .backgroundColor('#fff')
                    .justifyContent(FlexAlign.Start)

                    Button('提交')
                        .width(200)
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({top : vp2vp(20)})
                        .onClick(()=>{
                            promptAction.showToast({message : '提交成功'})
                            this.isPush = true
                        })
                }
                // .justifyContent(FlexAlign.Start)

            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F6F6F6')

        }
        .mode(NavigationMode.Stack)
        .title('调查问卷')
        .linearGradient({
            direction: GradientDirection.Right,
            colors: [['#4a9fef', 0], ['#4a9fef', 1]]
        })
        .titleMode(NavigationTitleMode.Mini)
    }
}