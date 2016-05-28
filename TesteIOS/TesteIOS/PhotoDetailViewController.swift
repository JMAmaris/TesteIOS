//
//  PhotoDetailViewController.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    internal var adItem: Ad!
    internal var currentPhotoIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
    }
    
    private func initLayout() {
        let backView: GalleryHeaderView = NSBundle.mainBundle().loadNibNamed(String(GalleryHeaderView), owner: self, options: nil)[0] as! GalleryHeaderView
        backView.frame = self.view.frame
        backView.isFullScreen = true
        backView.currentIndex = self.currentPhotoIndex
        backView.adItem = self.adItem
        self.view = backView
        
        let backButton: UIButton = UIButton(frame: CGRectMake(10.0, 30.0, 40.0, 40.0))
        backButton.setImage(UIImage(named: "backIcon"), forState: .Normal)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)
        backButton.addTarget(self, action: #selector(PhotoDetailViewController.navigateBackAction(_:)), forControlEvents: .TouchUpInside)
        backButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        backButton.layer.cornerRadius = backButton.frame.height / 2.0
        self.view.addSubview(backButton)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: UIButton Actions
    
    @IBAction func navigateBackAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }

}
