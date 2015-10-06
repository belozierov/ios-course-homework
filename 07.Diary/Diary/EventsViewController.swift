
import UIKit

class EventsViewController : UIViewController {
    
    @IBOutlet weak var switcher: UISegmentedControl!
    @IBAction func switcherChange(sender: UISegmentedControl) {
        buildCellsForMode(switcher.selectedSegmentIndex)
    }

    var width : CGFloat = 0
    var height : CGFloat = 0
    var position : CGFloat = 0
    var day = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = UIScreen.mainScreen().bounds.width - 16
        height = UIScreen.mainScreen().bounds.height
        switcher.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        buildCellsForMode(switcher.selectedSegmentIndex)
    }
    
    func buildCellsForMode(mode: Int) {
        
        deleteAllSubViews()
        position = 86
        
        var array = [Record]()
        for i in 0...2 {
            if let arraySection = diary.database[i] {
                array += arraySection
            }
        }
        
        if mode == 0 { 
            for record in array {
                cellViewForRecord(record, withY: position, showDate: true)
                if position >= height { break }
            }
        } else {
            day = 0
            var index = 0
            while position < height {
                let tempIndex = index
                for i in tempIndex..<array.count {
                    let formatterDate = NSDateFormatter()
                    formatterDate.dateStyle = .ShortStyle
                    let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -day, toDate: NSDate(), options: [])
                    if formatterDate.stringFromDate(array[i].date) == formatterDate.stringFromDate(date!) {
                        let showDate = tempIndex == index ? true : false
                        cellViewForRecord(array[i], withY: position, showDate: showDate)
                        index++
                    } else { break }
                }
                if tempIndex == index {
                    emptyCellWithDateAgo(day, withY: position)
                } else { day++ }
            }
        }
    }
    
    func cellViewForRecord(record: Record, withY y: CGFloat, showDate: Bool) {
        
        let containerView = UIView(frame: CGRectMake(8, y, width, 44))
        switch record.mood {
        case 0 : containerView.tintColor = UIColor.init(red: 236.0/255.0, green: 180.0/255.0, blue: 56.0/255.0, alpha: 1)
        case 2 : containerView.tintColor = UIColor.init(red: 212.0/255.0, green: 21.0/255.0, blue: 27.0/255.0, alpha: 1)
        default : containerView.tintColor = UIColor.blackColor()
        }
        
        if showDate {
            let dateView = UITextView(frame: CGRectMake(0, -8, 80, 44))
            let formatterDate = NSDateFormatter()
            formatterDate.dateStyle = .ShortStyle
            dateView.text = formatterDate.stringFromDate(record.date)
            dateView.font = UIFont.systemFontOfSize(16)
            dateView.userInteractionEnabled = false
            dateView.textColor = containerView.tintColor
            containerView.addSubview(dateView)
        }
        
        let moodView = UIImageView(frame: CGRectMake(70, 0, 20, 20))
        switch record.mood {
        case 0 : moodView.image = UIImage(named: "sunny")
        case 1 : moodView.image = UIImage(named: "cloudy")
        case 2 : moodView.image = UIImage(named: "rain")
        default : break
        }
        moodView.tintColor = containerView.tintColor
        containerView.addSubview(moodView)
        
        let titleView = UITextView(frame: CGRectMake(95, -8, width - 95, 44))
        titleView.text = record.title
        titleView.font = UIFont.systemFontOfSize(16)
        let newSize = titleView.sizeThatFits(CGSize(width: width - 95, height: CGFloat.max))
        titleView.frame.size = newSize
        titleView.userInteractionEnabled = false
        titleView.textColor = containerView.tintColor
        containerView.addSubview(titleView)
        
        containerView.frame.size = CGSize(width: width, height: newSize.height)
        position += newSize.height
        
        view.addSubview(containerView)
    }
    
    func emptyCellWithDateAgo (days: Int, withY y: CGFloat) {
        
        let dateView = UITextView(frame: CGRectMake(8, y - 8, 80, 44))
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        let date = NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -days, toDate: NSDate(), options: [])
        dateView.text = formatterDate.stringFromDate(date!)
        dateView.font = UIFont.systemFontOfSize(16)
        dateView.textColor = UIColor.grayColor()
        dateView.userInteractionEnabled = false
        position += 44
        day++
        view.addSubview(dateView)
        
    }
    
    func deleteAllSubViews() {
        for subView in view.subviews {
            if !subView.hidden {
                subView.removeFromSuperview()
            }
        }
    }
    
}
