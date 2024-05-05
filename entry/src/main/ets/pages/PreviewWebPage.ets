import webview from '@ohos.web.webview';
import { vp2vp } from '../utils/base';

@Entry
@Component
struct PreviewWebPage {
  // webController: webview.WebviewController = new webview.WebviewController()

  build() {
    Navigation() {
      Scroll() {
        // Web({
        //   src: $rawfile('index.html'),
        //   controller: this.webController
        // })
        //   .width('100%')
        //   .height('100%')

        Column(){
          Column(){
            Text('面试宝典隐私政策')
              .fontSize(vp2vp(36))
              .fontWeight(FontWeight.Bold)
          }
          .width('100%')

          Text('本指引是面试宝典app开发者 "空指针异常工作室"（以下简称“开发者”）为处理你的个人信息而制定。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('开发者处理的信息')
            .fontSize(vp2vp(22))
            .fontWeight(FontWeight.Bold)
            .margin({ top: vp2vp(30) })

          Text('根据法律规定，开发者仅处理实现app功能所必要的信息。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('为了实现语音输入等功能，开发者将在获取你的明示同意后，访问你的麦克风。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('为了保存打卡照片，开发者将在获取你的明示同意后，使用你的相册（仅写入）权限。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('第三方插件信息/SDK信息')
            .fontSize(vp2vp(22))
            .fontWeight(FontWeight.Bold)
            .margin({ top: vp2vp(30) })

          Text('为实现特定功能，开发者可能会接入由第三方提供的插件/SDK。第三方插件/SDK的个人信息处理规则，请以其公示的官方说明为准。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('你的权益')
            .fontSize(vp2vp(22))
            .fontWeight(FontWeight.Bold)
            .margin({ top: vp2vp(30) })

          Text('关于你的个人信息，你可以通过以下方式与开发者联系，行使查阅、复制、更正、删除等法定权利。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('若你在app中注册了账号，你可以通过以下方式与开发者联系，申请注销你在app中使用的账号。在受理你的申请后，开发者承诺在十五个工作日内完成核查和处理，并按照法律法规要求处理你的相关信息。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('邮箱：2576556095@qq.com')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('开发者对信息的存储')
            .fontSize(vp2vp(22))
            .fontWeight(FontWeight.Bold)
            .margin({ top: vp2vp(30) })

          Text('开发者承诺，除法律法规另有规定外，开发者对你的信息的保存期限应当为实现处理目的所必要的最短时间。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('信息的使用规则')
            .fontSize(vp2vp(22))
            .fontWeight(FontWeight.Bold)
            .margin({ top: vp2vp(30) })

          Text('开发者将会在本指引所明示的用途内使用收集的信息')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('如开发者使用你的信息超出本指引目的或合理范围，开发者必须在变更使用目的或范围前，再次以邮件方式告知并征得你的明示同意。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('信息对外提供')
            .fontSize(vp2vp(22))
            .fontWeight(FontWeight.Bold)
            .margin({ top: vp2vp(30) })

          Text('开发者承诺，不会主动共享或转让你的信息至任何第三方，如存在确需共享或转让时，开发者应当直接征得或确认第三方征得你的单独同意。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('开发者承诺，不会对外公开披露你的信息，如必须公开披露时，开发者应当向你告知公开披露的目的、披露信息的类型及可能涉及的信息，并征得你的单独同意。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Medium)
            .margin({ top: vp2vp(10) })

          Text('你认为开发者未遵守上述约定，或有其他的投诉建议、或未成年人个人信息保护相关问题，可通过以下方式与开发者联系；或者向微信进行投诉。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Bolder)
            .margin({ top: vp2vp(40) })

          Text('邮箱：2576556095@qq.com')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Bolder)
            .margin({ top: vp2vp(1) })

          Text('更新日期：2024-05-01')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Bolder)
            .margin({ top: vp2vp(1) })


          Text('生效日期：2024-05-01')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Bolder)
            .margin({ top: vp2vp(1) })

          Text('本app已对用户的信息处理进行了逐一、如实的说明，并保证如有变更会及时更新指引。')
            .fontSize(vp2vp(18))
            .fontWeight(FontWeight.Bolder)
            .margin({ top: vp2vp(1) })
        }
        .alignItems(HorizontalAlign.Start)
        .margin({left : 8, right : 8})

      }
      .width('100%')
      // .height('100%')
    }
    .width('100%')
    // .height('300%')
    .title('隐私政策')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
  }
}