//
//  GalleryHeaderView.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit
import SDWebImage

class GalleryHeaderView: UIView, UIScrollViewDelegate {

    @IBOutlet private weak var photoScrollView: UIScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var adPriceLabel: UILabel!
    @IBOutlet private weak var adTitleLabel: UILabel!
    @IBOutlet private weak var adDateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var noImageLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!

    internal var isFullScreen: Bool = false
    internal var adItem: Ad! {
        didSet {
            self.configureView()
        }
    }
    internal var currentIndex: Int = 0
    
    private var photos: [String]!
    private var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.photoScrollView.delegate = self
        self.adPriceLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.noImageLabel.text = NSLocalizedString("no_image", comment: "")
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.gradientView.bounds
        self.gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor]
        self.gradientView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        self.expandButton.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        self.expandButton.layer.cornerRadius = self.expandButton.frame.height / 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var gFrame: CGRect = self.gradientLayer.frame
        gFrame.size.width = UIScreen.mainScreen().bounds.width
        self.gradientLayer.frame = gFrame
        
        self.configureView()
    }
    
    private func configureView() {
        self.expandButton.hidden = self.isFullScreen
        self.adPriceLabel.hidden = self.isFullScreen
        self.adTitleLabel.hidden = self.isFullScreen
        self.adDateLabel.hidden = self.isFullScreen
        self.gradientView.hidden = self.isFullScreen
        
        self.photos = self.adItem.getPhotosUrlStrings()
        self.pageControl.numberOfPages = self.photos.count
        self.pageControl.hidden = self.pageControl.numberOfPages == 1
        
        self.photoScrollView.subviews.forEach{ $0.removeFromSuperview() }
        for (i, photo) in self.photos.enumerate() {
            var frame: CGRect = CGRectZero
            frame.origin.x = self.frame.width * CGFloat(i)
            frame.origin.y = 0.0
            frame.size = CGSizeMake(self.frame.width, self.frame.height)
            let photoView: UIImageView = UIImageView(frame: frame)
            photoView.sd_setImageWithURL(NSURL(string: photo)!)
            photoView.contentMode = self.isFullScreen ? .ScaleAspectFit : .ScaleAspectFill
            photoView.layer.masksToBounds = true
            self.photoScrollView.addSubview(photoView)
        }
        
        self.photoScrollView.contentSize = CGSizeMake(self.frame.width * CGFloat(self.photos.count) + (self.photos.count > 1 ? 0 : 1), self.frame.height)
        self.photoScrollView.contentOffset = CGPointMake(self.photoScrollView.frame.width * CGFloat(self.currentIndex), 0.0)
        self.pageControl.currentPage = self.currentIndex
        
        if self.photos.count == 0 {
            self.photoScrollView.contentSize = CGSizeMake(self.frame.width + 1.0, self.frame.height)
            self.expandButton.hidden = true
            self.noImageLabel.hidden = false
        }
        
        self.adPriceLabel.text = "   \(self.adItem.price) "
        self.adTitleLabel.text = self.adItem.title
        self.adDateLabel.text = self.adItem.created
    }
    
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        self.pageControl.currentPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1
        self.currentIndex = self.pageControl.currentPage
    }

}
