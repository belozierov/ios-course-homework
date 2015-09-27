
import UIKit

func saveSetting (key: String, value: Bool) {
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setBool(value, forKey: key)
}

func loadSetting (key: String) -> Bool {
    let defaults = NSUserDefaults.standardUserDefaults()
    return defaults.boolForKey(key)
}

class SettingViewController: UITableViewController {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var switcherBackGround: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Параметри"
        let backButton = UIBarButtonItem(title: "< Назад", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        self.navigationItem.leftBarButtonItem = backButton
        
        if loadSetting("dateShow") {
            label1.text = "✓"
            label2.text = ""
        } else {
            label1.text = ""
            label2.text = "✓"
        }
        
        switcherBackGround.on = loadSetting("backgroundShow")
    }
    
    func goBack() {
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                saveSetting("dateShow", value: true)
                label1.text = "✓"
                label2.text = ""
            } else if indexPath.row == 1 {
                saveSetting("dateShow", value: false)
                label1.text = ""
                label2.text = "✓"
            }
        }
        
        if indexPath.section == 1 {
            if switcherBackGround.on.boolValue {
                switcherBackGround.on = false
                saveSetting("backgroundShow", value: false)
            } else {
                switcherBackGround.on = true
                saveSetting("backgroundShow", value: true)
            }
        }
        tableView.reloadData()
    }
    
}
