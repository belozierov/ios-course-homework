
import Foundation

extension NSDate {

    private func hoursFrom() -> Int {
        return NSCalendar.currentCalendar().components(.Hour, fromDate: self, toDate: NSDate(), options: []).hour
    }
    
    private func minutesFrom() -> Int {
        return NSCalendar.currentCalendar().components(.Minute, fromDate: self, toDate: NSDate(), options: []).minute
    }
    
    private func secondsFrom() -> Int {
        return NSCalendar.currentCalendar().components(.Second, fromDate: self, toDate: NSDate(), options: []).second
    }
    
    private func dayFrom() -> Int {
        return NSCalendar.currentCalendar().components(.Day, fromDate: self, toDate: NSDate(), options: []).day
    }
    
    private func today() -> Bool {
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        if formatterDate.stringFromDate(NSDate()) == formatterDate.stringFromDate(self) {
            return true
        } else {
            return false
        }
    }
    
    private func yesterday() -> Bool {
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        let yesterdayDate = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -1, toDate: NSDate(), options: [])
        if formatterDate.stringFromDate(yesterdayDate!) == formatterDate.stringFromDate(self) {
            return true
        } else {
            return false
        }
    }
    
    private func thisWeak() -> String? {
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .LongStyle
        let currentWeak = NSCalendar.currentCalendar().components([.Year, .WeekOfYear], fromDate: NSDate())
        let selfWeak = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Weekday], fromDate: self)
        if currentWeak.year == selfWeak.year && currentWeak.weekOfYear == selfWeak.weekOfYear {
            switch selfWeak.weekday {
            case 1 : return "Неділя"
            case 2 : return "Понеділок"
            case 3 : return "Вівторок"
            case 4 : return "Середа"
            case 5 : return "Четвер"
            case 6 : return "П'ятниця"
            case 7 : return "Субота"
            default : return nil
            }
        } else {
            return nil
        }
    }
    
    func printTime () -> String {
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        let formatterTime = NSDateFormatter()
        formatterTime.timeStyle = .ShortStyle
        switch self {
        case let a where a.dayFrom() > 7 : return formatterDate.stringFromDate(self)
        case let a where a.secondsFrom() < 60 : return "Щойно"
        case let a where a.minutesFrom() < 60 : return "\(a.minutesFrom()) хвилин назад"
        case let a where a.hoursFrom() < 4 : return "\(a.hoursFrom()) годин назад"
        case let a where a.today() : return formatterTime.stringFromDate(self)
        case let a where a.yesterday() : return "Вчора"
        case let a where a.thisWeak() != nil : return a.thisWeak()!
        default : return formatterDate.stringFromDate(self)
        }
    }

}