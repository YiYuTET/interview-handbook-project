import Prompt from '@system.prompt'
import router from '../utils/router'
// import router from '@ohos.router';
@Entry
@Component
struct FeedbackPage {

    build() {
        Navigation() {
            Column({ space: 10 }) {
                Row() {
                    Image($r('app.media.icon')).width(20)
                    Text('错误类型（可多选）').fontWeight(FontWeight.Bold)
                }.width('100%')

                Column({ space: 8 }) {
                    Row() {
                        Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
                            .select(false)
                            .selectedColor(0xed6f21)
                            .onChange((value: boolean) => {
                                console.info('Checkbox1 change is' + value)
                            })
                        Text('知识点不准确')
                    }.width('100%')

                    Row({ space: 3 }) {
                        Checkbox({ name: 'checkbox2', group: 'checkboxGroup' })
                            .select(false)
                            .selectedColor(0xed6f21)
                            .onChange((value: boolean) => {
                                console.info('Checkbox2 change is' + value)
                            })
                        Text('内容不准或错误')
                    }.width('100%')

                    Row({ space: 3 }) {
                        Checkbox({ name: 'checkbox3', group: 'checkboxGroup' })
                            .select(false)
                            .selectedColor(0xed6f21)
                            .onChange((value: boolean) => {
                                console.info('Checkbox3 change is' + value)
                            })
                        Text('题目重复')
                    }.width('100%')

                    Row({ space: 3 }) {
                        Checkbox({ name: 'checkbox4', group: 'checkboxGroup' })
                            .select(false)
                            .selectedColor(0xed6f21)
                            .onChange((value: boolean) => {
                                console.info('Checkbox4 change is' + value)
                            })
                        Text('其他')
                    }.width('100%')
                }

                Column() {
                    Text('问题描述（可多选）').width('90%').height(20)
                    TextArea({ placeholder: '请输入问题描述（可多选）' }).width('90%').height(120)
                    Blank()
                    Button('提交反馈').width('80%')
                        .onClick(() => {
                            Prompt.showToast({ message: '提交成功！' })
                            router.push({
                                url: 'pages/HomePage'
                            })
                        })
                }.width('100%').height(500)
            }.width('100%')

        }
        .titleMode(NavigationTitleMode.Mini)
        .title('意见反馈')
        .mode(NavigationMode.Stack)
    }
}