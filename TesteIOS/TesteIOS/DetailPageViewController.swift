//
//  DetailPageViewController.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit

class DetailPageViewController: UIPageViewController, UIPageViewControllerDataSource, PageContentTableViewControllerDelegate {

    private enum Segue: String {
        case PhotoDetail = "photoDetailSegue"
        case MapDetail = "mapDetailSegue"
    }
    
    internal var adsArray: [Ad] = []
    internal var currentIndex: Int = 0
    
    private var itemDetailsIndex: Int = 0
    private var currentPhotoIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
    }
    
    private func initLayout() {
        self.view.backgroundColor = UIColor.whiteColor()
        self.dataSource = self
        
        let backButton: UIButton = UIButton(frame: CGRectMake(10.0, 30.0, 40.0, 40.0))
        backButton.setImage(UIImage(named: "backIcon"), forState: .Normal)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
        backButton.addTarget(self, action: #selector(DetailPageViewController.navigateBackAction(_:)), forControlEvents: .TouchUpInside)
        backButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        backButton.layer.cornerRadius = backButton.frame.height / 2.0
        self.view.addSubview(backButton)
        
        self.setViewControllers([self.viewControllerAtIndex(self.currentIndex)!], direction: .Forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segue.PhotoDetail.rawValue {
            (segue.destinationViewController as! PhotoDetailViewController).adItem = self.adsArray[self.itemDetailsIndex]
            (segue.destinationViewController as! PhotoDetailViewController).currentPhotoIndex = self.currentPhotoIndex
        } else if segue.identifier == Segue.MapDetail.rawValue {
            (segue.destinationViewController as! MapDetailViewController).adItem = self.adsArray[self.itemDetailsIndex]
        }
    }
    
    
    // MARK: - PageViewControllerDatasource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        self.currentIndex = (viewController as! PageContentTableViewController).index
        
        guard self.currentIndex != 0 && self.currentIndex != NSNotFound else {
            return nil
        }
        
        self.currentIndex -= 1
        return self.viewControllerAtIndex(self.currentIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        self.currentIndex = (viewController as! PageContentTableViewController).index
        
        guard self.currentIndex != NSNotFound && self.currentIndex != self.adsArray.count - 1 else {
            return nil
        }
        
        self.currentIndex += 1
        return self.viewControllerAtIndex(self.currentIndex)
    }
    
    private func viewControllerAtIndex(index: Int) -> PageContentTableViewController? {
        guard self.adsArray.count > 0 && index >= 0 && index < self.adsArray.count else {
            return nil
        }
        
        let pageContentViewController: PageContentTableViewController = PageContentTableViewController(index: index, adItem: self.adsArray[index])
        pageContentViewController.delegate = self
        return pageContentViewController
    }
    
    
    // MARK: UIButton Actions
    
    @IBAction func navigateBackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    // MARK: PageContentTableViewControllerDelegate
    
    func showPhotosDetails(atIntdex index: Int, atPhotoIndex: Int) {
        self.itemDetailsIndex = index
        self.currentPhotoIndex = atPhotoIndex
        self.performSegueWithIdentifier(Segue.PhotoDetail.rawValue, sender: self)
    }
    
    func showAdMap(atIntdex index: Int) {
        self.itemDetailsIndex = index
        self.performSegueWithIdentifier(Segue.MapDetail.rawValue, sender: self)
    }

}
