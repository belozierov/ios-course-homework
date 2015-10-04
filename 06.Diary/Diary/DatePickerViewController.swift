
//need to fix indexPath

import UIKit

class DatePickerViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var object : Record?
    var indexPath : NSIndexPath?
    var enteredDate : NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enteredDate = (object?.date)!
        datePicker.date = (object?.date)!
        datePicker.maximumDate = NSDate()
        
        title = "Змінити дату"
        let rightButton = UIBarButtonItem(title: "Зараз", style: UIBarButtonItemStyle.Plain, target: self, action: "now")
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    override func viewWillDisappear(animated:Bool) {
        super.viewWillDisappear(animated)
        if enteredDate != datePicker.date {
            object?.date = datePicker.date
            object!.updatePlaceInDatebase(indexPath!)
        }
    }
    
    func now() {
        datePicker.date = NSDate()
    }
    
}

