//
//  AdCollectionViewCell.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit
import SDWebImage

protocol AdCollectionViewCellDelegate {
    func didPressShareButton(atCellIndex index: Int, withImage image: UIImage?)
}

class AdCollectionViewCell: UICollectionViewCell {

    static let internalSpaceHeight: CGFloat = 8.0
    static let labelMarginsWidth: CGFloat = 8.0
    
    @IBOutlet private weak var adPhotoImageView: UIImageView!
    @IBOutlet private weak var adNameLabel: UILabel!
    @IBOutlet private weak var adPriceLabel: UILabel!
    @IBOutlet private weak var shareIcon: UIButton!
    @IBOutlet weak var noImageLabel: UILabel!
    
    internal var delegate: AdCollectionViewCellDelegate?
    
    private var index: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 2.0
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1.0 / UIScreen.mainScreen().scale
        self.layer.masksToBounds = true
        
        self.shareIcon.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.shareIcon.layer.cornerRadius = self.shareIcon.frame.height / 2.0
        
        self.adPriceLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.noImageLabel.text = NSLocalizedString("no_image", comment: "")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.index = nil
        self.adPhotoImageView.sd_cancelCurrentImageLoad()
        self.adPhotoImageView.image = nil
        self.adNameLabel.text = ""
        self.adPriceLabel.text = ""
        self.noImageLabel.hidden = true
    }
    
    internal func configure(adItem: Ad, atIndex index: Int) {
        self.index = index
        
        if let photoUrl: String = adItem.getPhotosUrlStrings().first {
            self.adPhotoImageView.sd_setImageWithURL(NSURL(string: photoUrl)!)
        } else {
            self.noImageLabel.hidden = false
        }
        self.adNameLabel.text = adItem.title
        self.adPriceLabel.text = " " + adItem.price + " "
    }
    
    
    // MARK: UIButton Actions
    
    @IBAction func didPressShareButton(sender: AnyObject) {
        if self.index != nil {
            self.delegate?.didPressShareButton(atCellIndex: self.index!, withImage: self.adPhotoImageView.image)
        }
    }

}
