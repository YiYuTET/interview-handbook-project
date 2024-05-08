import web_webview from '@ohos.web.webview'
@Entry
@Component
struct webContentPage{
    webviewController: web_webview.WebviewController = new web_webview.WebviewController();
    build(){
        Column(){
            Web({ src: 'https://www.baidu.com', controller: this.webviewController})
        }
    }
}