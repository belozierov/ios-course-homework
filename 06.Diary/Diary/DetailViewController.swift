
import UIKit

class DetailViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var titleRecord: UITextView!
    @IBOutlet weak var textRecord: UITextView!
    @IBOutlet weak var tagRecord: UISegmentedControl!
    @IBAction func saveTag() {
        record?.mood = tagRecord.selectedSegmentIndex
        backgroundShow()
    }
    
    var titleHeight : CGFloat = 16
    var textHeight : CGFloat = 16
    var width : CGFloat = 0
    var idexPath : NSIndexPath?
    
    var record: Record?
    var backgroundEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightButton = UIBarButtonItem(title: "Дата", style: UIBarButtonItemStyle.Plain, target: self, action: "datePicker")
        self.navigationItem.rightBarButtonItem = rightButton
        
        width = UIScreen.mainScreen().bounds.width - 16
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        tagRecord.setImage(UIImage(named: "sunny"), forSegmentAtIndex: 0)
        tagRecord.setImage(UIImage(named: "cloudy"), forSegmentAtIndex: 1)
        tagRecord.setImage(UIImage(named: "rain"), forSegmentAtIndex: 2)

        backgroundEnable = loadSetting("backgroundShow")
        backgroundShow()
        
        placeholderForObject(titleRecord, saveText: false, placeholderEnable: true)
        placeholderForObject(textRecord, saveText: false, placeholderEnable: true)
        
        titleHeight += newTableViewCellSize(titleRecord).height
        textHeight += newTableViewCellSize(textRecord).height
        
        tagRecord.selectedSegmentIndex = (record?.mood)!
        textRecord.delegate = self
        titleRecord.delegate = self
    }
    
    func datePicker() {
         performSegueWithIdentifier("datePicker", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        title = formatter.stringFromDate((record?.date)!)
    }
    
    // MARK: - UIViewController background
    
    func backgroundShow() {
        if backgroundEnable {
            switch record!.mood {
                case 0 : view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-sunny")!)
                case 1 : view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-cloudy")!)
                case 2 : view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-rainy")!)
                default : break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "datePicker" {
            let controller = segue.destinationViewController as! DatePickerViewController
            controller.object = record
            controller.indexPath = idexPath
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - UITextView placeholders
    
    func placeholderForObject(object: UITextView, saveText: Bool, placeholderEnable: Bool) {
        var placeholder = ""
        var value = ""
        if object === textRecord {
            placeholder = "Введіть текст"
            if saveText { record?.text = object.text }
            value = (record?.text)!
        }
        else if object === titleRecord { 
            placeholder = "Введіть заголовок"
            if saveText { record?.title = object.text }
            value = (record?.title)!
        }
        if value.isEmpty {
            object.text = (placeholderEnable ? placeholder : "")
            object.textColor = (placeholderEnable ? .lightGrayColor() : .blackColor())
        } else {
            object.text = value
            object.textColor = UIColor.blackColor()
        }
    }
    
    // MARK: - UITextView actions
    
    func textViewDidBeginEditing(textView: UITextView) {
        placeholderForObject(textView, saveText: false, placeholderEnable: false)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        placeholderForObject(textView, saveText: true, placeholderEnable: true)
    }
    
    func textViewDidChange(textView: UITextView) {
        let newFrame = newTableViewCellSize(textView)
        
        if textView.frame.height != newFrame.height {
            textView.frame = newFrame
            
            if textView === titleRecord {
                titleHeight = newFrame.height + 16
            }
            
            if textView === textRecord {
                textHeight = newFrame.height + 16
            }
            
            tableView?.beginUpdates()
            tableView?.endUpdates()
        }
    }
    
    func newTableViewCellSize(textView: UITextView) -> CGRect {
        let newSize = textView.sizeThatFits(CGSize(width: width, height: CGFloat.max))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, width), height: newSize.height)
        return newFrame
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 1 : return titleHeight
        case 2 : return textHeight
        default : return 50
        }
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            switch textView {
            case titleRecord : textRecord.becomeFirstResponder()
            case textRecord : textView.resignFirstResponder()
            default : break
            }
            return false
        }
        return true
    }
    
}
