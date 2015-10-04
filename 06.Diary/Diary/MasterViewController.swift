
import UIKit

class MasterViewController: UITableViewController, UISearchResultsUpdating {
    
    var dateShow = true
    var cacheDatabase = diary
    var moodIndex = 0
    var searchController: UISearchController!
    var showSearchBar = true
    var resultsTableController : MasterViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if showSearchBar {
            let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
            self.navigationItem.rightBarButtonItem = addButton
            resultsTableController = storyboard!.instantiateViewControllerWithIdentifier("MasterViewController") as? MasterViewController
            resultsTableController?.showSearchBar = false
            searchController = UISearchController(searchResultsController: resultsTableController)
            searchController.searchResultsUpdater = self
            tableView.tableHeaderView = searchController.searchBar
            definesPresentationContext = true
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        dateShow = loadSetting("dateShow")
        tableView.reloadData()
    }
    
    // MARK: - Add new object 
    
    func insertNewObject(sender: AnyObject) {
        let newRecord = Record(title: "", mood: 0, text: "")
        cacheDatabase.insertObject(newRecord, section : 0, index: 0)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: .Automatic)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail",
        let indexPath = self.tableView.indexPathForSelectedRow {
            let controller = segue.destinationViewController as! DetailViewController
            controller.record = cacheDatabase[indexPath.section, indexPath.row]
            controller.idexPath = indexPath
            controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return cacheDatabase.database.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if cacheDatabase.database[section]?.count != 0 {
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
        if let result = cacheDatabase.database[section] {
            return result.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! MasterTableViewCell
        let object = cacheDatabase[indexPath.section, indexPath.row]
        cell.title.text = object!.title.isEmpty ? "Без заголовку" : object!.title
        cell.date.text = dateShow ? object?.date.printTime() :  ""
        switch object!.mood {
            case 0 : cell.mood.image = UIImage(named: "sunny")
            case 1 : cell.mood.image = UIImage(named: "cloudy")
            case 2 : cell.mood.image = UIImage(named: "rain")
            default : break
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if let _ = cacheDatabase[indexPath.section, indexPath.row] {
            cacheDatabase.database[indexPath.section]!.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchKey = searchController.searchBar.text!
        let result = Diary()
        result.database = diary.filterDatebaseByText(searchKey)
        resultsTableController?.cacheDatabase = result
        resultsTableController!.tableView.reloadData()
    }
    
}
