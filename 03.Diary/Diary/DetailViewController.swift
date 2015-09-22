
import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleRecord: UITextView!
    @IBOutlet weak var textRecord: UITextView!
    @IBOutlet weak var tagRecord: UISegmentedControl!
    @IBAction func saveRecord(sender: AnyObject) {
            record?.tags = tagRecord.selectedSegmentIndex
            backgroundShow()
    }

    var record: Diary?
    var backgroundEnable = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = record?.dateFormat
        
        tagRecord.setImage(UIImage(named: "sunny"), forSegmentAtIndex: 0)
        tagRecord.setImage(UIImage(named: "cloudy"), forSegmentAtIndex: 1)
        tagRecord.setImage(UIImage(named: "rain"), forSegmentAtIndex: 2)

        backgroundEnable = loadSetting("backgroundShow")
        backgroundShow()
        
        placeholderForObject(titleRecord, saveText: false, placeholderEnable: true)
        placeholderForObject(textRecord, saveText: false, placeholderEnable: true)
        
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
            object.textColor = UIColor.lightGrayColor()
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
}

