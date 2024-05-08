import { vp2vp } from '../utils/base'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'

@Component
struct MyCard{
    name : string
    num ?: string
    build(){
        Row(){
            Text(this.name).fontSize(vp2vp(12))
            if(this.num){
                Blank()
                Text(this.num).fontSize(vp2vp(12))
            }
            Image($r('app.media.icon_my_arrow'))
                .fillColor('#C3C3C5')
                .width(vp2vp(18))
                .height(vp2vp(18))
        }

        .width('80%')
        .height(50)
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({ left: vp2vp(15), right: vp2vp(15) })
    }
}

@Entry
@Component
struct AboutUsPage{
    build(){
        Navigation(){
            Scroll(){
                Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
                    Column(){
                        Row() {
                            Image($r('app.media.icon')).width(vp2vp(120)).height(vp2vp(120))
                            Text('面试宝典').fontSize(vp2vp(28)).fontWeight(FontWeight.Bold)
                        }.padding({right:25})
                        Text('搞定企业面试真题，就用面试宝典').fontSize(vp2vp(14)).fontWeight(FontWeight.Bold).fontColor($r('app.color.ih_gray_color'))
                        Column(){
                            MyCard({name : '评价宝典'})
                            MyCard({name : '宝典资质'})
                                .onClick(() => {
                                    router.pushUrl({
                                        url: 'pages/QualificationPage'
                                    })
                                })
                            MyCard({name : '宝典规则'})
                            MyCard({name : '举报信息'})
                                .onClick(() => {
                                    router.pushUrl({
                                        url: 'pages/ReportInformationPage'
                                    })
                                })
                            MyCard({name : '版权信息'})

                            MyCard({name : '热线电话', num : '10086'})
                            MyCard({name : '检查更新', num : 'v1.0.0'})
                                .onClick(() => {
                                    promptAction.showToast({
                                        message: '已是最新版本',
                                        duration: 200
                                    })
                                })
                        }.margin({top:vp2vp(20)})
                        .backgroundColor('#F5F5F5')
                        .border({width:1})
                        .borderRadius(10)
                    }.backgroundColor('#FFFFFF')
                    Column({space:5}){
                        Text('赣ICP备2022002607号')
                            .fontSize(12).fontColor('RGB(210,210,210)')
                        Text('宝典v1.0.0')
                            .fontSize(12).fontColor('RGB(210,210,210)')
                    }.margin({top:100})
                }
            }
        }
        .titleMode(NavigationTitleMode.Mini)
        .title('关于我们')
        .mode(NavigationMode.Stack)
    }
}