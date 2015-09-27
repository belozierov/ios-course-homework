
import Foundation

class Diary : NSObject, NSCoding {
    
    var date = NSDate()
    var title : String
    var tags : Int
    var text : String
    
    static var datebase = [Int : [Diary]]()
    static  var lastSortUpdate = NSDate()
    
    // MARK: - Sort records
    
    static func updateDatebaseOnTime() {
        let componentsUpdate = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: Diary.lastSortUpdate)
        let componentsCurrent = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: NSDate())
        switch (componentsUpdate, componentsCurrent) {
        case let (u, c) where u.year != c.year || u.weekOfYear != c.weekOfYear : Diary.updateDatebasedOnSection([0, 1], toSort: false)
        case let (u, c) where u.day != c.day : Diary.updateDatebasedOnSection([0], toSort: false)
        default : break
        }
       // Diary.updateDatebasedOnSection([0, 1], toSort: true)
        Diary.lastSortUpdate = NSDate()
    }
    
    static func updateDatebasedOnSection(sections: [Int], toSort: Bool) {
        for section in sections {
            if let sectionArray = Diary.datebase[section] {
                if let metaSectionArray = Diary.datebase[section + 1] {
                    Diary.datebase[section + 1] = sectionArray + metaSectionArray
                    Diary.datebase[section] = []
                    /*if toSort {
                        Diary.datebase[section + 1]!.sortInPlace {a, b in a.date.timeIntervalSince1970 > b.date.timeIntervalSince1970}
                    }*/
                } else {
                    Diary.datebase[section + 1] = sectionArray
                }
            }
        }
    }
    
    func updatePlaceInDatebase (indexPath: NSIndexPath) {
        let object = self
        Diary.datebase[indexPath.section]!.removeAtIndex(indexPath.row)
        let newSection = object.recordSection
        let objectDateIntervalSince1970 = object.date.timeIntervalSince1970
        if let array = Diary.datebase[newSection] {
            var insert = false
            for (index, value) in array.enumerate() {
                if value.date.timeIntervalSince1970 < objectDateIntervalSince1970 {
                    Diary.insertObject(object, section: newSection, index: index)
                    insert = true
                    break
                }
            }
            if !insert {
                Diary.insertObject(object, section: newSection, index: array.count)
            }
        } else {
            Diary.datebase[newSection] = [object]
        }
    }
    
    // MARK: - Return/insert records
    
    static func returnObject (section: Int, index: Int) -> Diary? {
        if let array = Diary.datebase[section] {
            return array[index]
        }
        return nil
    }
    
    static func insertObject (object: Diary, section : Int, index: Int) {
        if let _ = Diary.datebase[section] {
            Diary.datebase[section]?.insert(object, atIndex: index)
        } else {
            Diary.datebase[section] = [object]
        }
    }
    
    var recordSection : Int {
        let dateElements = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: date)
        let dateCurrent = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: NSDate())
        switch (dateElements, dateCurrent) {
        case let (e, c) where e.year != c.year || e.weekday != c.weekday : return 2
        case let (e,c) where e.day != c.day : return 1
        default : return 0
        }
    }
    
    @objc init (title: String, tags: Int, text: String) {
        self.title = title
        self.tags = tags
        self.text = text
    }
    
    // MARK: - Save Diary
    
    static func saveDiary() {
        if let url = Diary.localDataURL {
            let savedData = NSKeyedArchiver.archivedDataWithRootObject(Diary.datebase)
            savedData.writeToURL(url, atomically: true)
        }
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(Diary.lastSortUpdate)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "lastSortUpdate")
    }
    
    static func loadDiary() {
        if let url = Diary.localDataURL {
            if let data = NSData(contentsOfURL: url) {
                if let dateBase = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Int :[Diary]] {
                    Diary.datebase = dateBase
                    //Diary.datebase = [Int :[Diary]]()
                }
            }
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        if let lastSortUpdate = defaults.objectForKey("lastSortUpdate") as? NSData {
            if let dataAsDate = NSKeyedUnarchiver.unarchiveObjectWithData(lastSortUpdate) as? NSDate {
                Diary.lastSortUpdate = dataAsDate
            }
        }
        Diary.updateDatebaseOnTime()
    }
    
    static private var localDataURL: NSURL? = {
        do {
            let url = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
            return url.URLByAppendingPathComponent("Datebase.data")
        } catch { return nil }
        }()
    
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
        
}
