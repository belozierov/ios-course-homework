
import UIKit

class EventsViewController : UIViewController, UIScrollViewDelegate {
    
    var width : CGFloat = 0
    var height : CGFloat = 0
    var scrollView : UIScrollView?
    var endScrollView : CGFloat = 0
    
    var segmentedControl : UISegmentedControl?
    
    var startFirstCell : CGFloat = 0
    var endFirstCell : CGFloat = 0
    var startLastCell : CGFloat = 0
    var endLastCell : CGFloat = 0
    
    var startDayAgo = 0
    var endDayAgo = 0
    
    var countRecords = 0
    var startIndexRecord = 0
    var endIndexRecord = 0
    
    var arrayOfRecords = [Record]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = UIScreen.mainScreen().bounds.width - 16
        height = UIScreen.mainScreen().bounds.height - 140
        
        scrollView = UIScrollView(frame: CGRectMake(0, 86, width, height))
        scrollView?.delegate = self
        scrollView!.showsVerticalScrollIndicator = false
        view.addSubview(scrollView!)
        
        segmentedControl = UISegmentedControl(items: ["Календар", "Список"])
        segmentedControl?.selectedSegmentIndex = 0
        segmentedControl?.addTarget(self, action: "changeSegment", forControlEvents: .ValueChanged)
        navigationItem.titleView = segmentedControl
    }
    
    override func viewWillAppear(animated: Bool) {
        
        scrollView?.contentOffset.y = 0
        
        arrayOfRecords = []
        for i in 0...2 {
            if let arraySection = diary.database[i] {
                arrayOfRecords += arraySection
            }
        }
        
        countRecords = arrayOfRecords.count
        startFirstCell = 0
        endFirstCell = 0
        startLastCell = 0
        endLastCell = 0
        startDayAgo = 1
        endDayAgo = -1
        startIndexRecord = 1
        endIndexRecord = -1
        endScrollView = height + 400
        
        if segmentedControl?.selectedSegmentIndex == 0 {
            scrollView!.contentSize = CGSize(width: width, height: endScrollView)
            while endLastCell < height {
                addCellLast(true)
            }
        } else {
            while endLastCell < height && endIndexRecord != countRecords {
                addCellLast(true)
            }
            if endIndexRecord == countRecords {
                scrollView?.contentSize = CGSize(width: width, height: endLastCell)
            } else {
                scrollView?.contentSize = CGSize(width: width, height: endLastCell + 200)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        deleteAllSubViews()
    }
    
    func changeSegment() {
        deleteAllSubViews()
        viewWillAppear(true)
    }
    
    func cellViewForRecord(record: Record?, withY y: CGFloat, showDate: Bool, dayAgo: Int, index: Int) -> UIView {
        let containerView = UIView(frame: CGRectMake(8, y, width, 44))
        
        if record != nil {
            
            let moodView = UIImageView(frame: CGRectMake(75, 8, 20, 20))
            switch record!.mood {
            case 0 : containerView.tintColor = UIColor.init(red: 236.0/255.0, green: 180.0/255.0, blue: 56.0/255.0, alpha: 1)
            moodView.image = UIImage(named: "sunny")
            case 1 : containerView.tintColor = UIColor.blackColor()
            moodView.image = UIImage(named: "cloudy")
            case 2 : containerView.tintColor = UIColor.init(red: 212.0/255.0, green: 21.0/255.0, blue: 27.0/255.0, alpha: 1)
            moodView.image = UIImage(named: "rain")
            default : break
            }
            moodView.tintColor = containerView.tintColor
            containerView.addSubview(moodView)
            
            let titleView = UITextView(frame: CGRectMake(95, 0, width - 95, 44))
            titleView.text = record!.title
            titleView.font = UIFont.systemFontOfSize(16)
            let newSize = titleView.sizeThatFits(CGSize(width: width - 95, height: CGFloat.max))
            titleView.frame.size = newSize
            titleView.userInteractionEnabled = false
            titleView.textColor = containerView.tintColor
            containerView.addSubview(titleView)
            
            containerView.frame.size = CGSize(width: width, height: newSize.height + 8)
        } else {
            containerView.tintColor = UIColor.grayColor()
        }
        
        let dateView = UITextView(frame: CGRectMake(0, 0, 75, 44))
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        if record != nil {
            dateView.text = formatterDate.stringFromDate(record!.date)
        } else {
            let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -dayAgo, toDate: NSDate(), options: [])
            dateView.text = formatterDate.stringFromDate(date!)
        }
        dateView.font = UIFont.systemFontOfSize(16)
        dateView.userInteractionEnabled = false
        dateView.textColor = containerView.tintColor
        dateView.hidden = showDate ? false : true
        containerView.addSubview(dateView)
        
        let infoField = UITextView()
        infoField.hidden = true
        infoField.text = dayAgo.description + " " + index.description
        containerView.addSubview(infoField)
        
        return containerView
    }
    
    func addCellLast(last: Bool) {
        
        let direction = last ? 1 : -1
        var dayAgo = last ? endDayAgo : startDayAgo
        let endOfCell = last ? endLastCell : startFirstCell - 44
        var indexRecord = last ? endIndexRecord : startIndexRecord
        var outputRecord : Record?
        var dateShow = true
        var addNewView = true
        let checkArray = indexRecord + direction >= 0 && indexRecord + direction < countRecords ? true : false
        
        func comparDatesInIndexAndDayAgo(dayAgo: Int) -> Bool {
            if checkArray {
                let formatterDate = NSDateFormatter()
                formatterDate.dateStyle = .ShortStyle
                let dateOfIndex = arrayOfRecords[indexRecord + direction].date
                let dateAgo =  NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -dayAgo, toDate: NSDate(), options: [])
                return formatterDate.stringFromDate(dateOfIndex) == formatterDate.stringFromDate(dateAgo!)
            } else {
                return false
            }
        }
        
        if comparDatesInIndexAndDayAgo(dayAgo) {
            outputRecord = arrayOfRecords[indexRecord + direction]
            indexRecord += direction
            if last {
                endIndexRecord += direction
                dateShow = false
            } else {
                startIndexRecord += direction
            }
        } else if comparDatesInIndexAndDayAgo(dayAgo + direction) {
            outputRecord = arrayOfRecords[indexRecord + direction]
            dayAgo += direction
            indexRecord += direction
            if last {
                endIndexRecord += direction
                endDayAgo += direction
            } else {
                startIndexRecord += direction
                startDayAgo += direction
            }
        } else if segmentedControl?.selectedSegmentIndex == 0 {
            dayAgo += direction
            if last {
                endDayAgo += direction
            } else {
                startDayAgo += direction
            }
        } else if checkArray {
            outputRecord = arrayOfRecords[indexRecord + direction]
            let dayAgoTemp = outputRecord?.date.dayFrom()
            if comparDatesInIndexAndDayAgo(dayAgoTemp!) {
                if last {
                    endIndexRecord += direction
                    endDayAgo = dayAgoTemp!
                } else {
                    startIndexRecord += direction
                    startDayAgo = dayAgoTemp!
                }
            } else {
                if last {
                    endIndexRecord += direction
                    endDayAgo = dayAgoTemp! + 1
                } else {
                    startIndexRecord += direction
                    startDayAgo = dayAgoTemp! + 1
                }
            }
        } else {
            addNewView = false
            endScrollView = endLastCell
            scrollView!.contentSize = CGSize(width: width, height: endScrollView)
        }
        
        
        
        if addNewView {
            if startIndexRecord == 0 {
                startIndexRecord += direction
            }
            if endIndexRecord + 1 == countRecords {
                endIndexRecord += direction
            }
            let view = cellViewForRecord(outputRecord, withY: endOfCell, showDate: dateShow, dayAgo: dayAgo, index: indexRecord)
            if last {
                startLastCell = view.frame.origin.y
                endLastCell = startLastCell + view.frame.height
            } else {
                startFirstCell = view.frame.origin.y
                endFirstCell = startFirstCell + view.frame.height
            }
            scrollView?.addSubview(view)
        }
    }
    
    func deleteAllSubViews() {
        for subView in scrollView!.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y > 0 {
            if scrollView.contentOffset.y + height > startLastCell {
                if segmentedControl?.selectedSegmentIndex == 0 || endIndexRecord != countRecords {
                    addCellLast(true)
                } else {
                    scrollView.contentSize = CGSize(width: width, height: endLastCell)
                }
            } else if scrollView.contentOffset.y < endFirstCell {
                addCellLast(false)
            }
        }
        
        if scrollView.contentOffset.y + height > endScrollView - 200 {
            endScrollView += 400
            scrollView.contentSize = CGSize(width: width, height: endScrollView)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        cleanScrollView()
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        cleanScrollView()
    }
    
    func cleanScrollView() {
        for i in scrollView!.subviews {
            if i.frame.origin.y + i.frame.height < scrollView!.contentOffset.y ||
                i.frame.origin.y > scrollView!.contentOffset.y + height, let _ = i as? UIImageView {
                    i.removeFromSuperview()
            }
        }
        
        let sortedArray = scrollView!.subviews.sort({$0.frame.origin.y < $1.frame.origin.y})
        if sortedArray.count != 0 {
            let firstRecord = sortedArray.first
            startFirstCell = firstRecord!.frame.origin.y
            endFirstCell = startFirstCell + firstRecord!.frame.height
            let newStartCellInfo = (firstRecord!.subviews.last as! UITextView).text
            let startInfoArray = newStartCellInfo.characters.split {$0 == " "}.map(String.init)
            startDayAgo = Int(startInfoArray[0])!
            startIndexRecord = Int(startInfoArray[1])!
            
            var count = 0
            while (sortedArray[sortedArray.count - ++count].subviews.last as? UITextView) == nil {}
            let lastRecord = sortedArray[sortedArray.count - count]
            startLastCell = lastRecord.frame.origin.y
            endLastCell = startLastCell + lastRecord.frame.height
            let newLastCellInfo = (lastRecord.subviews.last as! UITextView).text
            let lastInfoArray = newLastCellInfo!.characters.split {$0 == " "}.map(String.init)
            endDayAgo = Int(lastInfoArray[0])!
            endIndexRecord = Int(lastInfoArray[1])!
        }
        
        if segmentedControl == 0 || endLastCell != endScrollView {
            if startIndexRecord == 0 {
                startIndexRecord--
            }
            if endIndexRecord + 1 == countRecords {
                endIndexRecord++
            }
            if scrollView!.contentOffset.y + height < endScrollView - 400 {
                endScrollView = scrollView!.contentOffset.y + height + 400
                scrollView!.contentSize = CGSize(width: width, height: endScrollView)
            }
        }
    }
    
}
