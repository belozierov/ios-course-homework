
import UIKit

class MasterViewController: UITableViewController {
    
    @IBOutlet weak var cells: UITableView!
    
    var dateShow = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        let settingsButton = UIBarButtonItem(title: "Параметри", style: UIBarButtonItemStyle.Plain, target: self, action: "goToSettings")
        self.navigationItem.leftBarButtonItem = settingsButton
        
        Diary.recordsDatebase = loadDiary()
        title = Diary.recordsDatebaseGrouped[0]?.count.description
        
        dateShow = loadSetting("dateShow")
    }
    
    func goToSettings() {
        performSegueWithIdentifier("settings", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        dateShow = loadSetting("dateShow")
        cells.reloadData()
    }
    
    /*func insertNewObject(sender: AnyObject) {
        Diary.recordsDatebase.insert(Diary(title: "", tags: 0, text: ""), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.reloadData()
    }*/
    
    /*func insertNewObject(sender: AnyObject) {
        let newRecord = Diary(title: "", tags: 0, text: "")
        Diary.recordsDatebase.insert(newRecord, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }*/
    
    func indexPathOfRecord(record: Diary, inDictionary: [Int: [Diary]]) -> NSIndexPath? {
        for (i, array) in inDictionary {
            for j in 0..<array.count {
                if array[j] === record {
                    return NSIndexPath(forRow: j, inSection: i)
                }
            }
        }
        
        return nil
        
    
    }
    
    func insertNewObject(sender: AnyObject) {
        let newRecord = Diary(title: "", tags: 0, text: "")
        Diary.recordsDatebase.insert(newRecord, atIndex: 0)
        if let indexPath = indexPathOfRecord(newRecord, inDictionary: Diary.recordsDatebaseGrouped) {
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
        tableView.reloadData()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let section = indexPath.section
                let array  = Diary.recordsDatebaseGrouped[section]
                let controller = segue.destinationViewController as! DetailViewController
                if array?[indexPath.row] != nil {
                    controller.record = array![indexPath.row]
                    controller.navigationItem.leftItemsSupplementBackButton = true
                }
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Diary.recordsDatebaseGrouped.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0 : return "Сьогодні"
        case 1 : return "Вчора"
        case 2 : return "Цього тижня"
        case 3 : return "Раніше"
        default : return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = Diary.recordsDatebaseGrouped[section]?.count {
            return result
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        //let section = indexPath.section
        let array  = Diary.recordsDatebaseGrouped[indexPath.section]
        let object = array![indexPath.row]
        cell.textLabel!.text = (object.title.isEmpty ? "Без заголовку" : object.title)
        cell.detailTextLabel!.text = dateShow ? object.dateFormat.0 :  ""
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        Diary.recordsDatebase.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
}

