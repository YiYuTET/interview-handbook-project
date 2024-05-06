import router from '../utils/router'
import { QuestionType, ResponseData, TagItem } from '../models'
import { requestGet } from '../utils/request'
import { PAGE_MAP } from '../constants'
import { vp2vp } from '../utils/base'


@Preview
@Component
export struct ProjectPage {
  @State
  projectList: QuestionType[] = []

  aboutToAppear() {
    // setTimeout(() => {
    //   this.projectList = [
    //     {
    //       "id": 396,
    //       "name": "后台管理系统",
    //       "icon": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/teach/%E5%9B%BE%E6%A0%87/%E5%90%8E%E5%8F%B0%E7%AE%A1%E7%90%86%E5%B0%81%E9%9D%A2.png",
    //       "describeInfo": "以vue技术栈为例的后台管理系统面试题整理",
    //       "displayNewestFlag": 0,
    //       "tags": [
    //         {
    //           "tagName": "人资项目",
    //           "nameColor": "#e9e5ff",
    //           "borderColor": "#a192fc"
    //         }
    //       ]
    //     },
    //     {
    //       "id": 397,
    //       "name": "在线问医平台(医疗类)",
    //       "icon": "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/teach/%E5%9B%BE%E6%A0%87/%E5%8C%BB%E7%96%97%E5%B0%81%E9%9D%A2.png",
    //       "describeInfo": "通过vue3+ts实现的在线医疗问诊相关技术整理",
    //       "displayNewestFlag": 0,
    //       "tags": [
    //         {
    //           "tagName": "在线医疗",
    //           "nameColor": "#e7f4dc",
    //           "borderColor": "#8ad94d"
    //         },
    //         {
    //           "tagName": "socket",
    //           "nameColor": "#fdecee",
    //           "borderColor": "#e3848e"
    //         },
    //         {
    //           "tagName": "vue3+ts",
    //           "nameColor": "#fdecee",
    //           "borderColor": "#e3848e"
    //         }
    //       ]
    //     }
    // }, 1000)
    requestGet('question/type', { type: 'items' })
      .then((res: ResponseData<QuestionType[]>) => {
        this.projectList = res.data
      })
  }

  build() {
    List() {
      ForEach(this.projectList, (item: QuestionType) => {
        ListItem() {
          Row() {
            Image(item.icon)
              .width(vp2vp(60))
              .height(vp2vp(80))
            Column() {
              Text(item.name).width('100%').margin({ bottom: vp2vp(5) }).fontSize(vp2vp(16))
              Row() {
                Text(item.describeInfo)
                  .width('100%')
                  .fontColor($r('app.color.ih_gray_color'))
                  .fontSize(vp2vp(12))
                  .maxLines(2)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .width('100%')
              .layoutWeight(1)
              .alignItems(VerticalAlign.Top)

              Row() {
                ForEach(item.tags, (tag: TagItem) => {
                  Text(tag.tagName)
                    .fontSize(vp2vp(10))
                    .lineHeight(vp2vp(10))
                    .padding(vp2vp(5))
                    .borderRadius(vp2vp(4))
                    .backgroundColor('#EDF2FF')
                    .fontColor('#3266EE')
                    .margin({ right: vp2vp(5) })
                })
              }
              .width('100%')
            }
            .padding({ left: vp2vp(15) })
          }
        }
        .padding({ top: vp2vp(15), bottom: vp2vp(15) })
        .height(vp2vp(110))
        .onClick(()=>{
          router.push({
            url: PAGE_MAP.project_list,
            params: {
              id: item.id,
              name: item.name
            }
          })
        })
      })
    }
    .padding(vp2vp(15))
    .height('100%')
    .width('100%')
    .divider({
      strokeWidth: 0.5,
      color: '#e4e4e4'
    })
  }
}