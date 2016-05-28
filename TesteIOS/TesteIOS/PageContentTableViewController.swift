//
//  PageContentTableViewController.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit

protocol PageContentTableViewControllerDelegate {
    func showPhotosDetails(atIntdex index: Int, atPhotoIndex: Int)
    func showAdMap(atIntdex index: Int)
}

class PageContentTableViewController: UITableViewController {
    
    private let galleryHeight: CGFloat = max(UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width) / 3.0
    
    internal var delegate: PageContentTableViewControllerDelegate?
    internal var index: Int!
    
    private var adItem: Ad!
    private var rowCount: Int = 2
    
    convenience init(index: Int, adItem: Ad) {
        self.init(nibName: String(PageContentTableViewController), bundle: NSBundle.mainBundle())
        
        self.index = index
        self.adItem = adItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initLayout()
    }
    
    private func initLayout() {
        let contentView: UIView = UIView(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.width, self.galleryHeight))
        contentView.backgroundColor = UIColor.blackColor()
        let headerView: GalleryHeaderView = NSBundle.mainBundle().loadNibNamed(String(GalleryHeaderView), owner: self, options: nil)[0] as! GalleryHeaderView
        headerView.frame = contentView.frame
        headerView.adItem = self.adItem
        headerView.expandButton.addTarget(self, action: #selector(PageContentTableViewController.expandPhotosAction(_:)), forControlEvents: .TouchUpInside)
        contentView.addSubview(headerView)
        self.tableView.tableHeaderView = contentView
        
        let footerContentView: UIView = UIView(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.width, ProfileFooterView.DefaultHeight))
        let footerView: ProfileFooterView = NSBundle.mainBundle().loadNibNamed(String(ProfileFooterView), owner: self, options: nil)[0] as! ProfileFooterView
        footerView.frame = footerContentView.frame
        footerView.userName = self.adItem.publisherName
        footerContentView.addSubview(footerView)
        self.tableView.tableFooterView = footerContentView
        
        self.tableView.registerNib(UINib(nibName: String(AdMapTableViewCell), bundle: nil), forCellReuseIdentifier: String(AdMapTableViewCell))
        
        self.rowCount += self.adItem.params.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil

        if indexPath.row < self.rowCount {
            switch indexPath.row {
            case 0: // Location
                let aCell: AdMapTableViewCell = tableView.dequeueReusableCellWithIdentifier(String(AdMapTableViewCell), forIndexPath: indexPath) as! AdMapTableViewCell
                aCell.configure(self.adItem)
                cell = aCell
            case self.rowCount - 1: // Description
                cell = tableView.dequeueReusableCellWithIdentifier("descriptionCell")
                if cell == nil {
                    cell = UITableViewCell(style: .Default, reuseIdentifier: "descriptionCell")
                }
                cell?.selectionStyle = .None
                cell?.backgroundColor = UIColor.clearColor()
                cell?.textLabel?.font = UIFont.systemFontOfSize(14.0)
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.lineBreakMode = .ByWordWrapping
                cell?.textLabel?.text = self.adItem.adDescription
                
            default: // Params
                cell = tableView.dequeueReusableCellWithIdentifier("paramCell")
                if cell == nil {
                    cell = UITableViewCell(style: .Value1, reuseIdentifier: "paramCell")
                }
                cell?.selectionStyle = .None
                cell?.backgroundColor = UIColor.clearColor()
                cell?.textLabel?.font = UIFont.systemFontOfSize(14.0)
                cell?.textLabel?.textColor = UIColor.grayColor()
                cell?.detailTextLabel?.font = UIFont.systemFontOfSize(15.0)
                cell?.detailTextLabel?.textColor = UIColor.blackColor()
                
                cell?.textLabel?.text = self.adItem.params[indexPath.row - 1].name
                cell?.detailTextLabel?.text = self.adItem.params[indexPath.row - 1].value
            }
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("nullCell")
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: "nullCell")
            }
            cell?.selectionStyle = .None
            cell?.backgroundColor = UIColor.clearColor()
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < self.rowCount {
            switch indexPath.row {
            case 0: return AdMapTableViewCell.DefaultHeight
            case self.rowCount - 1: return max(44.0, NSString(string: self.adItem.adDescription).boundingRectWithSize(CGSizeMake(UIScreen.mainScreen().bounds.width - 16.0 * 2.0, CGFloat.max), options: [.UsesFontLeading, .UsesLineFragmentOrigin], attributes: [NSFontAttributeName: UIFont.systemFontOfSize(14.0)], context: nil).size.height + 20.0)
            
            default: return 44.0
            }
        }
        return 0.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            self.delegate?.showAdMap(atIntdex: self.index)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: UIButton Actions
    
    @IBAction func expandPhotosAction(sender: AnyObject) {
        self.delegate?.showPhotosDetails(atIntdex: self.index, atPhotoIndex: (self.tableView.tableHeaderView!.subviews.first as! GalleryHeaderView).currentIndex)
    }
    
}
