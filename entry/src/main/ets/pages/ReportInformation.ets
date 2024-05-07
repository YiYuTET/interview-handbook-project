
@Builder
function information(content:string,title?:string){
  Text(title).fontColor(Color.Black)
    .fontWeight(FontWeight.Bold)
    .fontSize(18)
  Text(content).fontColor(Color.Black)
    .fontSize(14)
}

@Preview
@Component
struct ReportInformation{
  build(){
    Navigation(){
      Scroll(){
        Flex({direction:FlexDirection.Column,alignItems:ItemAlign.Center}){
          Column({space:20}) {
            information('4006018900','一、违法和不良信息举报电话：')
            information('tousujubao@meituan.com','二、举报邮箱：')
            Blank()
            information('以上渠道均可投诉举报：互联网违法和不良信息，' +
            '涉及未成年人保护，互联网算法推荐，谣言类信息，' +
            '生活服务类专项举报等相关问题')
          }.alignItems(HorizontalAlign.Start)
            .margin({top:10})
          // .border({width:1,color:Color.Red})
        }
      }
    }
    .titleMode(NavigationTitleMode.Mini)
    .title('举报信息')
    .mode(NavigationMode.Stack)
  }
}