import { HdNav } from '@itcast/basic/Index'
import { webview } from '@kit.ArkWeb'
import { router } from '@kit.ArkUI'

@Entry
@Component
struct AgreementPage {
  controller = new webview.WebviewController()
  @State
  title: string = ''
  @State
  src: string = ''

  aboutToAppear(): void {
    const params = router.getParams() as Record<string, string>
    this.title = params.title
    this.src = params.src
  }

  build() {
    Column() {
      HdNav({ title: this.title, showRightIcon: false })
      Web({
        src: this.src,
        controller: this.controller
      })
    }
    .width('100%')
    .height('100%')
  }
}