import dayjs from 'dayjs'
import { HmCalendarController } from '../controllers/HmCalendarController'

export interface HmCalendarSelectedDay {
  date: string
  text?: ResourceStr
  textColor?: ResourceColor
  backgroundColor?: ResourceColor
  borderRadius?: Length | BorderRadiuses
}

export enum HmCalendarType {
  MONTH,
  WEEK,
  MONTH_DOT
}

interface HmCalendarItem {
  date: number
  month: number
  year: number
  day?: number
  inMonth?: boolean
  selectedFlag?: boolean
  selectedText?: ResourceStr
  selectedTextColor?: ResourceColor
  selectedBackgroundColor?: ResourceColor
  selectedBorderRadius?: Length | BorderRadiuses
}

@Component
export struct HmCalendar {
  // week labels
  private weeks: ResourceStr[] = [
    $r('app.string.hm_calendar_sunday'),
    $r('app.string.hm_calendar_monday'),
    $r('app.string.hm_calendar_tuesday'),
    $r('app.string.hm_calendar_wednesday'),
    $r('app.string.hm_calendar_thursday'),
    $r('app.string.hm_calendar_friday'),
    $r('app.string.hm_calendar_saturday'),
  ]
  // default selected text
  private text: ResourceStr = $r('app.string.hm_calendar_clocked')
  // default selected color
  private color: ResourceColor = $r('app.color.hm_calendar_color')
  // default selected radius
  private radius: Length | BorderRadiuses = 14
  // default date format rule
  private format: string = 'YYYY-MM-DD'
  // selected day from parent component
  @Prop
  @Watch('onUpdateData')
  selectedDays: HmCalendarSelectedDay[] = []
  @Prop
  @Watch('onUpdateData')
  currentDate: string = dayjs().format(this.format)
  // click date event
  private onClickDate: (date: string) => void = () => 0
  // change month event
  private onChangeMonth: (month: string) => void = () => 0
  // calendar type
  private type: HmCalendarType = HmCalendarType.MONTH
  // calendar gutter
  private gutter: number = 4
  @State
  items: HmCalendarItem[] = []
  // calendar controller
  private controller: HmCalendarController | null = null
  // calendar rows
  private rowsAuto: boolean = false

  // init calendar data
  genData() {
    const items: HmCalendarItem[] = []
    const currDate = this.currentDate ? dayjs(this.currentDate) : dayjs()
    const selectedDays = this.selectedDays || []
    const LEN = 42

    // current month
    const currDays = currDate.daysInMonth()
    for (let index = 1; index <= currDays; index++) {
      const selectedDay = selectedDays.find(item => currDate.date(index).isSame(item.date, 'date'))
      const selectedFlag = !!selectedDay
      const selectedText: ResourceStr = selectedDay?.text || this.text
      const selectedTextColor: ResourceColor = selectedDay?.textColor || this.color
      const selectedBackgroundColor: ResourceColor = selectedDay?.backgroundColor || this.color
      const selectedBorderRadius: Length | BorderRadiuses = selectedDay?.borderRadius || this.radius

      items.push({
        date: index,
        month: currDate.month() + 1,
        year: currDate.year(),
        day: currDate.date(index).day(),
        inMonth: true,
        selectedFlag,
        selectedText,
        selectedTextColor,
        selectedBackgroundColor,
        selectedBorderRadius
      })
    }
    if (this.type === HmCalendarType.MONTH || this.type === HmCalendarType.WEEK) {
      // prev month
      const prevMonth = currDate.date(0)
      const prevMonthLastDate = prevMonth.date()
      const prevDays = prevMonth.day()
      if (prevDays < 6) {
        for (let index = 0; index <= prevDays; index++) {
          items.unshift({
            date: prevMonthLastDate - index,
            month: prevMonth.month() + 1,
            year: prevMonth.year()
          })
        }
      }
      // next month
      const nextMonth = currDate.date(currDays + 1)
      let appends = LEN - items.length
      if (this.rowsAuto) {
        appends = items.length > 35 ? LEN - items.length : LEN - items.length - 7
      }
      for (let index = 1; index <= appends; index++) {
        items.push({
          date: index,
          month: nextMonth.month() + 1,
          year: nextMonth.year()
        })
      }
    }

    if (this.type === HmCalendarType.WEEK) {
      const currDate = this.currentDate ? dayjs(this.currentDate) : dayjs()
      const weekIndex = Math.floor(currDate.date() / 7)
      return items.slice(weekIndex * 7, (weekIndex + 1) * 7)
    }

    return items
  }

  aboutToAppear() {
    this.items = this.genData()
    if (this.controller) {
      this.controller.prevMonth = () => {
        this.prevMonth()
      }
      this.controller.nextMonth = () => {
        this.nextMonth()
      }
      this.controller.currentMonth = () => {
        const date = dayjs()
        this.currentDate = date.format(this.format)
        this.onChangeMonth && this.onChangeMonth(date.format('YYYY-MM'))
      }
      this.controller.toggleMonth = (dateStr: string) => {
        const date = dayjs(dateStr)
        this.currentDate = date.format(this.format)
        this.onChangeMonth && this.onChangeMonth(date.format('YYYY-MM'))
      }
    }
  }

  prevMonth() {
    const date = dayjs(this.currentDate).subtract(1, 'month')
    this.currentDate = date.format(this.format)
    this.onChangeMonth && this.onChangeMonth(date.format('YYYY-MM'))
  }

  nextMonth() {
    const date = dayjs(this.currentDate).add(1, 'month')
    this.currentDate = date.format(this.format)
    this.onChangeMonth && this.onChangeMonth(date.format('YYYY-MM'))
  }

  onUpdateData() {
    this.items = this.genData()
  }

  @Builder
  btnBuilder(img: ResourceStr, onClick: () => void) {
    Row() {
      Image(img)
        .fillColor($r('app.color.hm_calendar_arrow'))
    }
    .width(20)
    .height(20)
    .backgroundColor($r('app.color.hm_calendar_bg'))
    .borderRadius(4)
    .onClick(() => onClick())
  }

  build() {
    if (this.type === HmCalendarType.MONTH || this.type === HmCalendarType.WEEK) {

      Column() {
        // toolBar
        if (this.type === HmCalendarType.MONTH) {
          Row() {
            Blank()
            this.btnBuilder($r('app.media.ic_public_arrow_left'), () => {
              this.prevMonth()
            })
            Text(dayjs(this.currentDate).format('YYYY-MM'))
              .width(100)
              .textAlign(TextAlign.Center)
              .fontSize(15)
              .fontColor($r('app.color.hm_calendar_valid'))
              .fontWeight(500)
            this.btnBuilder($r('app.media.ic_public_arrow_right'), () => {
              this.nextMonth()
            })
            Blank()
          }
          .width('100%')
          .height(50)
          .border({
            width: { bottom: 0.5 },
            color: $r('app.color.hm_calendar_bg')
          })
        }

        // weekBar + content
        GridRow({ columns: 7 }) {
          ForEach(this.weeks, (label: string) => {
            GridCol() {
              Text(label)
                .fontSize(15)
                .height(50)
                .fontWeight(500)
                .fontColor($r('app.color.hm_calendar_valid'))
            }
          })
          ForEach(this.items, (item: HmCalendarItem) => {
            GridCol() {
              Column() {
                if (item.selectedFlag) {
                  Text(item.date.toString())
                    .fontSize(14)
                    .width(28)
                    .aspectRatio(1)
                    .textAlign(TextAlign.Center)
                    .borderRadius(item.selectedBorderRadius)
                    .fontColor(Color.White)
                    .backgroundColor(item.selectedBackgroundColor)
                  Text(item.selectedText)
                    .fontSize(10)
                    .fontColor(item.selectedTextColor)
                    .layoutWeight(1)
                } else {
                  Text(item.date.toString())
                    .fontSize(14)
                    .width(28)
                    .aspectRatio(1)
                    .textAlign(TextAlign.Center)
                    .fontColor(item.inMonth ? $r('app.color.hm_calendar_valid') : $r('app.color.hm_calendar_invalid'))
                  Blank()
                }
              }
              .height(50)
              .justifyContent(FlexAlign.Center)
              .onClick(() => {
                const date = `${item.year}-${item.month.toString().padStart(2, '0')}-${item.date.toString()
                  .padStart(2, '0')}`
                this.onClickDate && this.onClickDate(date)
              })
            }
          })
        }
        .margin({ left: 6, right: 6 })
      }
    }
    else {
      GridRow({ columns: 7, gutter: this.gutter }) {
        ForEach(this.items, (item: HmCalendarItem) => {
          GridCol(item.date === 1 ? { offset: item.day } : {}) {
            Text()
              .width(this.gutter)
              .aspectRatio(1)
              .borderRadius(this.gutter / 2)
              .backgroundColor(item.selectedFlag ? Color.White : $r('app.color.hm_calendar_invalid'))
              .border(item.selectedFlag ? { width: this.gutter / 4, color: this.color } : {})
          }
        })
      }
      .width(this.gutter * 2 * 7)
    }
  }
}
