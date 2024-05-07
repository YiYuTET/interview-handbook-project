import { vp2vp } from '../utils/base'

@Builder
function MyCard(name:string,num?:string){
  Row(){
    Text(name).fontSize(vp2vp(12))
    if(num){
      Blank()
      Text(num).fontSize(vp2vp(12))
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

@Preview
@Component
struct AboutUs{
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
              MyCard('评价宝典')
              MyCard('宝典资质')
              MyCard('宝典规则')
              MyCard('举报信息')
              MyCard('版权信息')
              MyCard('热线电话','10086')
              MyCard('检查更新','好赞，当前已是最新版本')
            }.margin({top:vp2vp(20)})
            .backgroundColor('#F5F5F5')
            .border({width:1})
            .borderRadius(10)
          }.backgroundColor('#FFFFFF')
          Column({space:5}){
            Text('ICP备案号：京ICP备10211739号-17A>')
              .fontSize(12).fontColor('RGB(210,210,210)')
            Text('宝典v12.20.404 build301934')
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