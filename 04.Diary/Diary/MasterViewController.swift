
import UIKit

class MasterViewController: UITableViewController {
    
    var dateShow = true
    var width : CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        let settingsButton = UIBarButtonItem(title: "Параметри", style: UIBarButtonItemStyle.Plain, target: self, action: "goToSettings")
        self.navigationItem.leftBarButtonItem = settingsButton
        
        Diary.loadDiary()
        //title = Diary.lastSortUpdate.description
    }
    
    func goToSettings() {
        performSegueWithIdentifier("settings", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        dateShow = loadSetting("dateShow")
        tableView.reloadData()
    }
    
    // MARK: - Add new object 
    
    func insertNewObject(sender: AnyObject) {
        let newRecord = Diary(title: "", tags: 0, text: "")
        Diary.insertObject(newRecord, section : 0, index: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let controller = segue.destinationViewController as! DetailViewController
                controller.record = Diary.returnObject(indexPath.section, index: indexPath.row)
                controller.idexPath = indexPath
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if Diary.datebase.count <= 1 {
            return nil
        }
        if let _ = Diary.datebase[section] {
            switch section {
            case 0 : return "Сьогодні"
            case 1 : return "Цього тижня"
            case 2 : return "Раніше"
            default : return nil
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let result = Diary.datebase[section] {
            return result.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        let object = Diary.returnObject(indexPath.section, index: indexPath.row)
        //cell.title.numberOfLines = 0
        cell.title.text = (object!.title.isEmpty ? "Без заголовку" : object!.title)

        //var a = cell.title.frame
        //a.size = CGSize(width: 2000000, height: 1)
        //cell.title.frame = a

        cell.date.text = dateShow ? object?.date.printTime() :  ""
        switch object!.tags {
            case 0 : cell.tags.image = UIImage(named: "sunny")
            case 1 : cell.tags.image = UIImage(named: "cloudy")
            case 2 : cell.tags.image = UIImage(named: "rain")
            default : break
        }
        return cell
    }
    
    /*override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        //let newSize = cell.title.sizeThatFits(CGSize(width: width, height: CGFloat.max))
        //var newFrame = cell.title.frame
        //newFrame.size = CGSize(width: max(newSize.width, width), height: newSize.height)
        return 200 
    }*/
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = Diary.returnObject(indexPath.section, index: indexPath.row) {
            Diary.datebase[indexPath.section]!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
}
