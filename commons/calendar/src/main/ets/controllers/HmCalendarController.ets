const defaultFn = () => {

}

export class HmCalendarController {
  prevMonth: () => void = defaultFn
  nextMonth: () => void = defaultFn
  currentMonth: () => void = defaultFn
  toggleMonth: (dateStr: string) => void = defaultFn
}