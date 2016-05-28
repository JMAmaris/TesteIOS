//
//  AdsListCollectionViewController.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit
import SDWebImage

class AdsListCollectionViewController: UICollectionViewController, ColumnsCollectionViewLayoutDelegate, AdCollectionViewCellDelegate {
    
    private enum Segue: String {
        case Detail = "detailSegue"
    }
    
    private var adsArray: [Ad] = []
    private var selectedIndex: Int?
    private var loadingAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
        self.initData()
    }
    
    private func initLayout() {
        self.title = NSLocalizedString("ads_title", comment: "")
        
        if let layout: ColumnsCollectionViewLayout = self.collectionView?.collectionViewLayout as? ColumnsCollectionViewLayout {
            layout.delegate = self
        }
        
        self.collectionView?.registerNib(UINib(nibName: String(AdCollectionViewCell), bundle: nil), forCellWithReuseIdentifier: String(AdCollectionViewCell))
    }
    
    private func initData() {
        if let savedAds: [Ad] = self.loadAds() {
            self.adsArray = savedAds
        } else {
            self.requestAds()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        if let layout: ColumnsCollectionViewLayout = self.collectionView?.collectionViewLayout as? ColumnsCollectionViewLayout {
            layout.resetLayout()
        }
        self.collectionView?.reloadData()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Segue.Detail.rawValue {
            let detailPageViewController: DetailPageViewController = segue.destinationViewController as! DetailPageViewController
            detailPageViewController.adsArray = self.adsArray
            detailPageViewController.currentIndex = self.selectedIndex!
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.adsArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AdCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(String(AdCollectionViewCell), forIndexPath: indexPath) as! AdCollectionViewCell
    
        cell.configure(self.adsArray[indexPath.row], atIndex: indexPath.row)
        cell.delegate = self
    
        return cell
    }
    
    
    // MARK: ColumnsCollectionViewLayoutDelegate
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let adFirstPhoto: (id: Int, width: Int, height: Int)? = self.adsArray[indexPath.row].photos.data.first
        if adFirstPhoto != nil {
            return (width * CGFloat(adFirstPhoto!.height)) / CGFloat(adFirstPhoto!.width)
        } else {
            return width
        }
    }
    
    func collectionView(collectionView: UICollectionView, heightForTitleAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        return max(17.0, NSString(string: self.adsArray[indexPath.row].title).boundingRectWithSize(CGSizeMake(width - AdCollectionViewCell.labelMarginsWidth, CGFloat.max), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14.0)], context: nil).size.height)
    }
    

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier(Segue.Detail.rawValue, sender: self)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    
    // MARK: AdCollectionViewCellDelegate
    
    func didPressShareButton(atCellIndex index: Int, withImage image: UIImage?) {
        let adTitle: String = self.adsArray[index].title
        let adImage: UIImage = image == nil ? UIImage() : image!
        let shareActivity: UIActivityViewController = UIActivityViewController(activityItems: [adTitle, adImage], applicationActivities: nil)
        shareActivity.excludedActivityTypes = [UIActivityTypeAssignToContact]
        self.presentViewController(shareActivity, animated: true, completion: nil)
    }
    
    
    // MARK: NSCoding
    
    private func saveAds() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(self.adsArray, toFile: Ad.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save ads...")
        }
    }
    
    private func loadAds() -> [Ad]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Ad.ArchiveURL.path!) as? [Ad]
    }
    
    
    // MARK: UIButton Actions
    
    @IBAction func refeshAdsAction(sender: AnyObject) {
        self.requestAds()
    }
    
    
    // MARK: API Request
    
    internal func requestAds() {
        self.showLoading()
        DataManager.sharedInstance.getAdsList { (ads: [Ad], error: NSError?) in
            self.dismissLoading()
            if error == nil {
                self.adsArray = ads
                self.collectionView?.reloadData()
                self.saveAds()
            } else {
                let errorAlert: UIAlertController = UIAlertController(title: nil, message: NSLocalizedString("error_fetching_ads", comment: ""), preferredStyle: .Alert)
                errorAlert.addAction(UIAlertAction(title: NSLocalizedString("ok_button", comment: ""), style: .Cancel, handler: nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    private func showLoading() {
        self.loadingAlert = UIAlertController(title: nil, message: NSLocalizedString("loading", comment: ""), preferredStyle: .Alert)
        let spinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        spinner.color = UIColor.blackColor()
        spinner.center = CGPointMake(130.5, 65.5)
        spinner.startAnimating()
        self.loadingAlert!.view.addSubview(spinner)
        self.presentViewController(self.loadingAlert!, animated: true, completion: nil)
    }
    
    private func dismissLoading() {
        self.loadingAlert?.dismissViewControllerAnimated(true, completion: { 
            self.loadingAlert = nil
        })
    }

}
