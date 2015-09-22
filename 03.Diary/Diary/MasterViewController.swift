
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
        
        dateShow = loadSetting("dateShow")
    }
    
    func goToSettings() {
        performSegueWithIdentifier("settings", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        dateShow = loadSetting("dateShow")
        cells.reloadData()
    }

    func insertNewObject(sender: AnyObject) {
        Diary.recordsDatebase.insert(Diary(title: "", tags: 0, text: ""), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destinationViewController as! DetailViewController
                controller.record = Diary.recordsDatebase[indexPath.row]
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Diary.recordsDatebase.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let object = Diary.recordsDatebase[indexPath.row]
        cell.textLabel!.text = (object.title.isEmpty ? "Без заголовку" : object.title)
        cell.detailTextLabel!.text = dateShow ? object.dateFormat :  ""
        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        Diary.recordsDatebase.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
}

