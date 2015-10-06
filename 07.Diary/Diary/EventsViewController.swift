
import UIKit

class EventsViewController : UIViewController {
    
    @IBOutlet weak var switcher: UISegmentedControl!

    var width : CGFloat = 0
    var count : CGFloat = 86
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = UIScreen.mainScreen().bounds.width - 16
        switcher.selectedSegmentIndex = 0
    }
    
    override func viewWillAppear(animated: Bool) {
        count = 86
        for (_, section) in diary.database {
            for record in section {
                view.addSubview(cellViewForRecord(record, withY: count))
            }
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        deleteAllSubViews()
    }
    
    func cellViewForRecord(record: Record, withY y: CGFloat) -> UIView {
        
        let containerView = UIView(frame: CGRectMake(8, y, width, 44))
        switch record.mood {
        case 0 : containerView.tintColor = UIColor.init(red: 236.0/255.0, green: 180.0/255.0, blue: 56.0/255.0, alpha: 1)
        case 2 : containerView.tintColor = UIColor.init(red: 212.0/255.0, green: 21.0/255.0, blue: 27.0/255.0, alpha: 1)
        default : containerView.tintColor = UIColor.blackColor()
        }
        
        let dateView = UITextView(frame: CGRectMake(0, -8, 80, 30))
        let formatterDate = NSDateFormatter()
        formatterDate.dateStyle = .ShortStyle
        dateView.text = formatterDate.stringFromDate(record.date)
        dateView.font = UIFont.systemFontOfSize(16)
        dateView.userInteractionEnabled = false
        dateView.textColor = containerView.tintColor
        containerView.addSubview(dateView)
        
        let moodRect = CGRectMake(70, 0, 20, 20)
        let moodView = UIImageView(frame: moodRect)
        switch record.mood {
        case 0 : moodView.image = UIImage(named: "sunny")
        case 1 : moodView.image = UIImage(named: "cloudy")
        case 2 : moodView.image = UIImage(named: "rain")
        default : break
        }
        moodView.tintColor = UIColor.blueColor()
        containerView.addSubview(moodView)
        
        let titleView = UITextView(frame: CGRectMake(95, -8, width - 95, 40))
        titleView.text = record.title
        titleView.font = UIFont.systemFontOfSize(16)
        let newSize = titleView.sizeThatFits(CGSize(width: width - 95, height: CGFloat.max))
        var newFrame = titleView.frame
        newFrame.size = CGSize(width: max(newSize.width, width - 95), height: newSize.height)
        titleView.frame = newFrame
        titleView.userInteractionEnabled = false
        titleView.textColor = containerView.tintColor
        containerView.addSubview(titleView)
        
        if newFrame.size.height > 44 {
            containerView.frame = CGRectMake(8, y, width, newFrame.size.height)
        }
        count += containerView.frame.height
        
        return containerView
    }
    
    func deleteAllSubViews() {
        //var count = 0
        for subView in view.subviews {
            //if count != 0 {
                subView.removeFromSuperview()
                count++
            //}
        }
    }
    
}
