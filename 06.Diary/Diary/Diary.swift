
import Foundation

var diary = Diary()

class Diary {
    
    var database = [Int : [Record]]()
    var lastSortUpdate = NSDate()
    //var needToRefilter = true
    
    subscript (section: Int, index: Int) -> Record? {
        get {
            return (database[section])?[index]
        }
    }
    
    func insertObject (object: Record, section : Int, index: Int) {
        if let _ = database[section] {
            database[section]?.insert(object, atIndex: index)
        } else {
            database[section] = [object]
        }
    }
    
    func filterDatebaseByMood(mood: Int?) -> [Int : [Record]] {
        if mood != nil {
            var filteredDatebase = [Int : [Record]]()
            for (section, array) in diary.database {
                filteredDatebase[section] = array.filter{$0.mood == mood}
            }
            return filteredDatebase
        } else {
            return diary.database
        }
    }
    
    func filterDatebaseByText(titlePrefix: String?) -> [Int : [Record]] {
        if titlePrefix != nil {
            var filteredDatebase = [Int : [Record]]()
            for (section, array) in diary.database {
                filteredDatebase[section] = array.filter{
                    $0.title.rangeOfString(titlePrefix!, options: [.CaseInsensitiveSearch, .AnchoredSearch], range: nil, locale: nil) != nil
                }
            }
            return filteredDatebase
        } else {
            return diary.database
        }
    }
    
    // MARK: - Update database on time
    
    func updateDatebaseOnTime() {
        let componentsUpdate = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: self.lastSortUpdate)
        let componentsCurrent = NSCalendar.currentCalendar().components([.Year, .WeekOfYear, .Day], fromDate: NSDate())
        switch (componentsUpdate, componentsCurrent) {
        case let (u, c) where u.year != c.year || u.weekOfYear != c.weekOfYear : updateDatebasedOnSection([0, 1])
        case let (u, c) where u.day != c.day : updateDatebasedOnSection([0])
        default : break
        }
        lastSortUpdate = NSDate()
    }
    
    private func updateDatebasedOnSection(sections: [Int]) {
        for section in sections {
            if let sectionArray = database[section] {
                if let metaSectionArray = database[section + 1] {
                    database[section + 1] = sectionArray + metaSectionArray
                } else {
                    database[section + 1] = sectionArray
                }
                database[section]?.removeAll()
            }
        }
    }
    
    // MARK: - Save Diary

    func saveDiary() {
        if let url = diary.localDataURL {
            let savedData = NSKeyedArchiver.archivedDataWithRootObject(diary.database)
            savedData.writeToURL(url, atomically: true)
        }
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(diary.lastSortUpdate)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "lastSortUpdate")
    }
    
    func loadDiary() {
        diary.database = [Int :[Record]]()
        if let url = diary.localDataURL,
        let data = NSData(contentsOfURL: url),
        let dataBase = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [Int :[Record]]{
            diary.database = dataBase
            //diary.database = [Int :[Record]]()
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        if let lastSortUpdate = defaults.objectForKey("lastSortUpdate") as? NSData,
        let dataAsDate = NSKeyedUnarchiver.unarchiveObjectWithData(lastSortUpdate) as? NSDate {
            diary.lastSortUpdate = dataAsDate
        }
        diary.updateDatebaseOnTime()
    }
    
    lazy private var localDataURL: NSURL? = {
        do {
            let url = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: true)
            return url.URLByAppendingPathComponent("Datebase.data")
        } catch { return nil }
        }()
}

