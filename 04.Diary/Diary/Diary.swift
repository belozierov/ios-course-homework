
import Foundation

func saveDiary() {
    if let url = Diary.localDataURL {
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(Diary.recordsDatebase)
        savedData.writeToURL(url, atomically: true)
    }
}

func loadDiary() -> [Diary] {
    if let url = Diary.localDataURL {
        if let data = NSData(contentsOfURL: url) {
            if let dateBase = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Diary] {
                return dateBase
            }
        }
    }
    return []
}

class Diary : NSObject, NSCoding {
    
    var date = NSDate()
    var title : String
    var tags : Int
    var text : String
    
    static var recordsDatebase = [Diary]()
    
    static var recordsDatebaseGrouped : [Int : [Diary]] = {
        var count = 0
        var sum = Diary.recordsDatebase.count
        var result = [Int : [Diary]]()
        for iGroup in 0...3 {
            if count >= sum { break }
            var tempDict = [Diary]()
            for i in count..<sum {
                if iGroup != Diary.recordsDatebase[count].dateFormat.1 { break }
                tempDict.append(Diary.recordsDatebase[count])
                ++count
            }
            result[iGroup] = tempDict
            
            
            
            /*while Diary.recordsDatebase[count].dateFormat.1 == iGroup {
            tempDict.append(Diary.recordsDatebase[count])
            ++count
            if count == Diary.recordsDatebase.count { break }
            }
            
            result[iGroup] = tempDict*/
            
        }
        
        return result
        }()
    
    var dateFormat : (String, Int) {
        
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        let formatterTime = NSDateFormatter()
        formatterTime.timeStyle = .ShortStyle
        
        let dayNameDict = [
            1 : "Неділя",
            2 : "Понеділок",
            3 : "Вівторок",
            4 : "Середа",
            5 : "Четвер"
        ]
        
        let dateElements = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Weekday, .Day], fromDate: date)
        let dateCurrent = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: NSDate())
        let dateCurrent2 = NSCalendar.currentCalendar()
        
        if formatterDate.stringFromDate(date) == formatterDate.stringFromDate(dateCurrent2.dateByAddingUnit([.Day], value: -1, toDate: NSDate(), options: [])!) {
            return ("Вчора", 1)
        }
        if dateElements.year == dateCurrent.year && dateElements.weekOfYear == dateCurrent.weekOfYear {
            if dateElements.day == dateCurrent.day {
                return (formatterTime.stringFromDate(date), 0)
            }
            return (dayNameDict[dateElements.weekday]!, 2)
        } else {
            return (formatterDate.stringFromDate(date), 3)
        }
    }
    @objc init (title: String, tags: Int, text: String) {
        self.title = title
        self.tags = tags
        self.text = text
    }
    
    // MARK: - Save Diary
    
    required init(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObjectForKey("date") as? NSDate ?? NSDate()
        title = aDecoder.decodeObjectForKey("title") as? String ?? ""
        tags = aDecoder.decodeObjectForKey("tags") as? Int ?? 0
        text = aDecoder.decodeObjectForKey("text") as? String ?? ""
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(tags, forKey: "tags")
        aCoder.encodeObject(text, forKey: "text")
    }
    
    static var localDataURL: NSURL? = {
        do {
            let url = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
            return url.URLByAppendingPathComponent("Datebase.data")
        } catch { return nil }
        }()
    
}