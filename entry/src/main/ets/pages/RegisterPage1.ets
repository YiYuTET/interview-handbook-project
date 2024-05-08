import promptAction from '@ohos.promptAction'
import { PAGE_MAP } from '../constants'
import { vp2vp } from '../utils/base'
import router from '@ohos.router'
import PreferenceUtil from '../utils/PreferenceUtil'
import common from '@ohos.app.ability.common'
@Entry
@Component
struct RegisterPage {

    //获取上下文
    context = getContext(this) as common.UIAbilityContext
    @State username: string = ''
    @State password: string = ''
    @State confirmPassword:string = ''
    @State isAgree: boolean = false

    isValidAccount(account: string): boolean {
        const accountRegex = /^[a-zA-Z0-9]{6,15}$/;
        const phoneRegex = /^1[3-9]\d{9}$/;
        const emailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;

        return accountRegex.test(account) || phoneRegex.test(account) || emailRegex.test(account);
    }
    // 验证用户输入密码合法性
    isValidPassword(password: string): boolean {
        const passwordRegex = /^[a-zA-Z0-9]{8,12}$/;
        return passwordRegex.test(password);
    }

    register(){
        //用户名为空
        if (!this.username) {
            return promptAction.showToast({ message: '请输入用户名或电话号码' })
        }
        //密码为空
        if (!this.password) {
            return promptAction.showToast({ message: '请输入密码' })
        }

        //确认密码为空
        if (!this.confirmPassword) {
            return promptAction.showToast({ message: '请输入确认密码' })
        }
        // 未选用户协议
        if (!this.isAgree) {
            return promptAction.showToast({ message: '请勾选已阅读并同意' })
        }

        if(this.isValidAccount(this.username) && this.isValidPassword(this.password) &&this.isValidPassword(this.confirmPassword)){
            if (this.password === this.confirmPassword) {
                router.replaceUrl({
                    url: 'pages/LoginPage',
                    params: {
                        username: this.username,
                        password: this.password
                    }
                })
            }
            else {
                return promptAction.showToast({ message: '账户或密码输入不合法' })
            }
        }
        else {
            return promptAction.showToast({ message: '账户或密码输入不合法' })
        }

        const PREF_KEY = 'userAccountPassword'


        let userAccountInfo: string[] = [this.username, this.password]
        PreferenceUtil.putPreferenceValue(PREF_KEY,userAccountInfo)

    }
    build() {
        Navigation() {
            Scroll() {
                Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
                    Column() {
                        Image($r('app.media.icon'))
                            .width(vp2vp(150))
                            .height(vp2vp(150))

                        Text('面试宝典')
                            .fontSize(vp2vp(32))
                            .margin({ bottom: vp2vp(15) })

                        Text('搞定企业面试真题，就用面试宝典')
                            .fontSize(vp2vp(16))
                            .fontColor($r('app.color.ih_gray_color'))
                    }
                    .padding(20)

                    Column({space:15}) {
                        Row(){
                            Text('用户账号:')
                                .width(100)
                                .height(44)
                                .fontSize(20)
                                .borderRadius(5)
                            TextInput({ placeholder: '请输入用户名或电话号码', text: this.username })
                                .width(240)
                                .height(44)
                                .fontSize(18)
                                .border({width:2,color:'#fa711d'})
                                .placeholderColor('#C3C3C5')
                                .caretColor('#fa711d')
                                .onChange((value)=>{
                                    this.username = value
                                })
                                .onBlur(()=> {
                                    if (!this.isValidAccount(this.username)) {
                                        promptAction.showToast({ message: '用户账户输入不合法' });
                                    }

                                })

                        }
                        .width('95%')
                        Row(){
                            Text('用户密码:')
                                .width(100)
                                .height(44)
                                .fontSize(20)
                                .borderRadius(5)

                            TextInput({ placeholder: '请输入密码', text: this.password, })
                                .type(InputType.Password)
                                .showPasswordIcon(false)
                                .width(240)
                                .height(44)
                                .fontSize(18)
                                .border({width:2,color:'#fa711d'})
                                .placeholderColor('#C3C3C5')
                                .caretColor('#fa711d')
                                .onChange((value)=>{
                                    this.password = value
                                })
                                .onBlur(()=>{
                                    if (!this.isValidPassword(this.password)){
                                        promptAction.showToast({ message: '用户密码输入不合法' })
                                    }
                                })
                        }
                        .width('95%')

                        Row(){
                            Text('确认密码:')
                                .width(100)
                                .height(44)
                                .fontSize(20)
                                .borderRadius(5)

                            TextInput({ placeholder: '请再次输入密码', text: this.confirmPassword, })
                                .type(InputType.Password)
                                .showPasswordIcon(false)
                                .width(240)
                                .height(44)
                                .fontSize(18)
                                .border({width:2,color:'#fa711d'})
                                .placeholderColor('#C3C3C5')
                                .caretColor('#fa711d')
                                .onChange((value)=>{
                                    this.confirmPassword = value

                                })
                                .onBlur(()=>{
                                    if (!this.isValidPassword(this.confirmPassword)){
                                        promptAction.showToast({ message: '用户密码输入不合法' })
                                    }
                                })
                        }
                        .width('95%')

                        Row() {
                            Checkbox()
                                .selectedColor('#fa711d')
                                .size({ width: vp2vp(16), height: vp2vp(14) })
                                .select(this.isAgree)
                                .onChange((val) => {
                                    this.isAgree = val
                                })

                            Text('已阅读并同意')
                                .fontSize(vp2vp(16))
                                .fontColor($r('app.color.ih_gray_color'))
                                .padding({ right: vp2vp(4) })

                            Text('用户协议')
                                .fontSize(vp2vp(16))
                                .fontColor('#fa711d')
                                .padding({ right: vp2vp(4) })
                                .onClick(() => {
                                    router.pushUrl({
                                        url: PAGE_MAP.user_license
                                    })
                                })
                            Text('和')
                                .fontSize(vp2vp(16))
                                .fontColor($r('app.color.ih_gray_color'))
                                .padding({ right: vp2vp(4) })


                            Text('隐私政策')
                                .fontSize(vp2vp(16))
                                .fontColor('#fa711d')
                                .onClick(() => {
                                    router.pushUrl({
                                        url: PAGE_MAP.preview_web
                                    })
                                })
                        }
                        .width('100%')
                        .margin({ bottom: vp2vp(15) })


                        Button({ type: ButtonType.Normal}){
                            Text('确认注册账号')
                                .fontSize(28)
                                .fontColor('#ffffff')
                        }
                        .width('100%')
                        .backgroundColor('#fc9c1c')
                        .borderRadius(vp2vp(4))
                        .height(vp2vp(44))
                        .onClick(() => {
                            this.register()
                        })
                    }.padding(vp2vp(10))
                }
            }
        }
        .titleMode(NavigationTitleMode.Mini)
        .mode(NavigationMode.Stack)
        .mode(NavigationMode.Stack)
    }
}