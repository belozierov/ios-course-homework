
import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var object : Diary?
    var indexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.date = (object?.date)!
        datePicker.maximumDate = NSDate()
        
        title = "Змінити дату"
        let backButton = UIBarButtonItem(title: "< Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        let rightButton = UIBarButtonItem(title: "Зараз", style: UIBarButtonItemStyle.Plain, target: self, action: "now")
        self.navigationItem.rightBarButtonItem = rightButton

    }
    
    func goBack() {
        object?.date = datePicker.date
        self.dismissViewControllerAnimated(true, completion: {})
        object!.updatePlaceInDatebase(indexPath!)
    }
    
    func now() {
        datePicker.date = NSDate()
    }
}

