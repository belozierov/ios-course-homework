
//need to fix moodSwitcher

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var moodSwitcher: UISegmentedControl!
    @IBAction func filterMood(sender: AnyObject) {
        setViewControllers([viewControllerAtIndex(moodSwitcher.selectedSegmentIndex)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    //private let dataFilterDatebaseByMoodCache = NSCache()
    
    override func viewDidLoad() {
        self.dataSource = self
        moodSwitcher.selectedSegmentIndex = 0
        moodSwitcher.setImage(UIImage(named: "sunny"), forSegmentAtIndex: 0)
        moodSwitcher.setImage(UIImage(named: "cloudy"), forSegmentAtIndex: 1)
        moodSwitcher.setImage(UIImage(named: "rain"), forSegmentAtIndex: 2)
        setViewControllers([viewControllerAtIndex(0)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    private func viewControllerAtIndex(index: Int) -> UIViewController! {
        let viewController = storyboard!.instantiateViewControllerWithIdentifier("MasterViewController") as! MasterViewController
        viewController.showSearchBar = false
        viewController.moodIndex = index
        viewController.cacheDatabase = Diary()
        /*if let cacheDatabase = dataFilterDatebaseByMoodCache.objectForKey(index) where !diary.needToRefilter {
            viewController.cacheDatabase.database = cacheDatabase as! [Int : [Record]]
        } else {
            for i in 0...2 {
                dataFilterDatebaseByMoodCache.setObject(diary.filterDatebaseByMood(i), forKey: i)
            }
            diary.needToRefilter = false
            viewController.cacheDatabase.database = diary.filterDatebaseByMood(index)
        }*/
        viewController.cacheDatabase.database = diary.filterDatebaseByMood(index)
        moodSwitcher.selectedSegmentIndex = index
        return viewController
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! MasterViewController).moodIndex
        if index == 2 {
            return nil
        }
        index++
        return viewControllerAtIndex(index)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! MasterViewController).moodIndex
        if index == 0 {
            return nil
        }
        index--
        return viewControllerAtIndex(index)
    }
    
}
