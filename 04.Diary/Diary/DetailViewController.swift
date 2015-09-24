
import UIKit

class DetailViewController: UITableViewController, UITextViewDelegate {

    @IBOutlet weak var titleRecord: UITextView!
    @IBOutlet weak var textRecord: UITextView!
    @IBOutlet weak var tagRecord: UISegmentedControl!
    @IBAction func saveTag() {
        record?.tags = tagRecord.selectedSegmentIndex
        backgroundShow()
    }
    
    var cell1 : CGFloat = 50
    var cell2 : CGFloat = 16
    var cell3 : CGFloat = 16
    var width : CGFloat = 304
    
    var record: Diary?
    var backgroundEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let (date, _) = record!.dateFormat
        title = date

        tagRecord.setImage(UIImage(named: "sunny"), forSegmentAtIndex: 0)
        tagRecord.setImage(UIImage(named: "cloudy"), forSegmentAtIndex: 1)
        tagRecord.setImage(UIImage(named: "rain"), forSegmentAtIndex: 2)

        backgroundEnable = loadSetting("backgroundShow")
        backgroundShow()
        
        placeholderForObject(titleRecord, saveText: false, placeholderEnable: true)
        placeholderForObject(textRecord, saveText: false, placeholderEnable: true)
        
        cell2 += newTableViewCellSize(titleRecord).height
        cell3 += newTableViewCellSize(textRecord).height
        
        tagRecord.selectedSegmentIndex = (record?.tags)!
        textRecord.delegate = self
        titleRecord.delegate = self
    }
    
    // MARK: - UIViewController background
    
    func backgroundShow() {
        if backgroundEnable {
            switch record!.tags {
                case 0 : view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-sunny")!)
                case 1 : view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-cloudy")!)
                case 2 : view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-rainy")!)
                default : break
            }
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
                cell2 = newFrame.height + 16
            }
            
            if textView === textRecord {
                cell3 = newFrame.height + 16
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
        let section = indexPath.section
        let row = indexPath.row
        switch (section, row) {
            case (1, 0) : return cell2
            case (2, 0) : return cell3
            default : return cell1
        }
    }
    
}
