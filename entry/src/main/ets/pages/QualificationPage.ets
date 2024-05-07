
@Component
struct card{
    @Prop content:string
    build(){
        Column() {
            Text(this.content).fontSize(18)
                .fontColor('RGB(100,100,100)')
                .margin({ top: 14, left: 20 })
            Blank()
            Divider()
        }.width('100%')
        .height(50)
        .alignItems(HorizontalAlign.Start)
    }

}
@Entry
@Component
struct qualificationPAge{
    @State content:string = undefined
    build(){
        Navigation(){
            Scroll(){
                Flex({direction:FlexDirection.Row,alignItems:ItemAlign.Center}){
                    Column(){
                        card({content:'营业执照'})
                        card({content:'广播电视节目制作经营许可证'})
                        card({content:'增值电信业务经营许可证'})
                        card({content:'药品医疗器械网络信息服务备案'})
                        card({content:'药品网络交易服务第三方平台备案凭证'})
                        card({content:'医疗器械网络交易服务第三方平台备案凭证'})
                        card({content:'审图号于甲级测绘资格证书号'})
                        card({content:'网络交易第三方平台提供者备案号'})
                    }


                    // .width('100%')
                    // .border({width:1,color:'RGB(220,220,220)'})
                }
            }
        }
        .titleMode(NavigationTitleMode.Mini)
        .title('宝典资质')
        .mode(NavigationMode.Stack)
    }
}