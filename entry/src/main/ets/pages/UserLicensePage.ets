import webview from '@ohos.web.webview';
import { vp2vp } from '../utils/base';

@Entry
@Component
struct UserLicensePage {

    build() {
        Navigation() {
            Scroll() {

                Column(){
                    Column(){
                        Text('软件用户许可协议')
                            .fontSize(vp2vp(36))
                            .fontWeight(FontWeight.Bold)

                        Text('版本号: 1.0.0')
                            .fontSize(vp2vp(22))
                            .fontWeight(FontWeight.Bold)
                            .margin({ top: vp2vp(10) })

                        Text('生效日期: 2024-05-01')
                            .fontSize(vp2vp(22))
                            .fontWeight(FontWeight.Bold)
                            .margin({ top: vp2vp(10) })
                    }
                    .width('100%')

                    Text('欢迎使用面试宝典APP（以下简称“本软件”）。在安装、使用本软件之前，请仔细阅读以下用户许可协议（以下简称“协议”）。通过安装、使用本软件，您（即“用户”）表明已阅读、理解并同意遵守本协议的所有条款和条件。如果您不同意本协议的任何部分，请不要安装或使用本软件。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('1. 定义与解释')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('本软件指由空指针异常工作室开发并提供的移动应用程序及其所有相关文档、更新和补丁。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('用户指下载、安装或以其他方式使用本软件的个人或实体。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('2. 许可范围')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('空指针异常工作室特此授予您个人、非排他性、不可转让、有限的许可，允许您在遵守本协议的前提下安装和使用本软件。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('3. 使用限制')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('您不得对本软件进行逆向工程、解码、修改或创作衍生作品。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('不得出租、转售、分发或以其他方式商业利用本软件。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('禁止移除或篡改本软件中的任何版权或其他所有权声明。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('4. 用户责任')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('您应对使用本软件的行为及其后果负责，包括输入数据的准确性、合法性及适当性。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('若因您的不当使用导致任何损害，空指针异常工作室不承担任何责任。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('5. 数据保护与隐私')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('我们承诺按照隐私政策处理您的个人信息。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('使用本软件可能涉及数据传输，您同意我们按隐私政策收集、使用和存储必要数据。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('6. 知识产权')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('本软件及其包含的所有内容、技术、商标、专利等知识产权均归空指针异常工作室所有。除本协议明确授予的权利外，未赋予您任何其他权利或许可。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('7. 维护和支持')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('空指针异常工作室可自行决定提供软件更新和维护，但不保证一定提供。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('对于免费版本的用户，技术支持可能受限或需额外付费。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('8. 有限保证与免责声明')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('本软件按“现状”提供，不提供任何形式的明示或暗示保证，包括但不限于适销性、适用性保证。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('在任何情况下，对于间接、附带、特殊或惩罚性损害，空指针异常工作室概不负责。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('9. 终止')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('您可随时卸载本软件以终止本协议。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('如您违反本协议，空指针异常工作室有权单方面终止本协议，并要求您停止使用本软件。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('10. 法律适用与争议解决')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('本协议受中华人民共和国法律管辖。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('因本协议产生的任何争议，双方应首先通过友好协商解决；协商不成时，提交至法院诉讼解决。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('11. 其他')
                        .fontSize(vp2vp(22))
                        .fontWeight(FontWeight.Bold)
                        .margin({ top: vp2vp(30) })

                    Text('本协议构成双方就本软件使用达成的完整协议，取代此前所有口头或书面的沟通')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })

                    Text('如本协议任何条款被认定无效或不可执行，不影响其余条款的有效性。')
                        .fontSize(vp2vp(18))
                        .fontWeight(FontWeight.Medium)
                        .margin({ top: vp2vp(10) })
                }
                .alignItems(HorizontalAlign.Start)
                .margin({left : 8, right : 8})

            }
            .width('100%')
            // .height('100%')
        }
        .width('100%')
        // .height('300%')
        .title('用户许可协议')
        .titleMode(NavigationTitleMode.Mini)
        .mode(NavigationMode.Stack)
    }
}