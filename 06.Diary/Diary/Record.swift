
import Foundation

class Record : NSObject, NSCoding {
    
    var date = NSDate()
    var title : String
    var mood : Int
    var text : String
    
    var recordSection : Int {
        let dateElements = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: date)
        let dateCurrent = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: NSDate())
        switch (dateElements, dateCurrent) {
        case let (e, c) where e.year != c.year || e.weekOfYear != c.weekOfYear : return 2
        case let (e, c) where e.day != c.day : return 1
        default : return 0
        }
    }
    
    @objc init (title: String, mood: Int, text: String) {
        self.title = title
        self.mood = mood
        self.text = text
    }
    
    func updatePlaceInDatebase (indexPath: NSIndexPath) {
        let object = self
        diary.database[indexPath.section]!.removeAtIndex(indexPath.row)
        let newSection = object.recordSection
        //let indexPathSection = newSection
        //var indexPathRow = 0
        let objectDateIntervalSince1970 = object.date.timeIntervalSince1970
        if let array = diary.database[newSection] {
            var insert = false
            for (index, value) in array.enumerate() {
                if value.date.timeIntervalSince1970 < objectDateIntervalSince1970 {
                    diary.insertObject(object, section: newSection, index: index)
                    //indexPathRow = index
                    insert = true
                    break
                }
            }
            if !insert {
                diary.insertObject(object, section: newSection, index: array.count)
                //indexPathRow = array.count
            }
        } else {
            diary.database[newSection] = [object]
        }
        //indexPath = NSIndexPath(forRow: indexPathRow, inSection: indexPathSection)
    }
    
    required init(coder aDecoder: NSCoder) {
        date = aDecoder.decodeObjectForKey("date") as! NSDate
        title = aDecoder.decodeObjectForKey("title") as! String
        mood = aDecoder.decodeObjectForKey("mood") as! Int
        text = aDecoder.decodeObjectForKey("text") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(mood, forKey: "mood")
        aCoder.encodeObject(text, forKey: "text")
    }
    
}
