//
//  AdMapTableViewCell.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit
import MapKit

class AdMapTableViewCell: UITableViewCell {

    static let DefaultHeight: CGFloat = 150.0
    
    private let RegionDistance: Double = 1000.0
    
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var gradientView: UIView!
    @IBOutlet private weak var adCityLabel: UILabel!
    @IBOutlet private weak var locationImageView: UIImageView!
    @IBOutlet private weak var expandImageView: UIImageView!
    
    internal var adItem: Ad!
    
    private var gradientLayer: CAGradientLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer.frame = self.gradientView.bounds
        self.gradientLayer.colors = [UIColor.blackColor().colorWithAlphaComponent(0.7).CGColor, UIColor.clearColor().CGColor]
        self.gradientView.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        self.locationImageView.tintColor = UIColor(red: 231.0 / 255.0, green: 76.0 / 255.0, blue: 60.0 / 255.0, alpha: 1.0)
        
        self.expandImageView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        self.expandImageView.layer.cornerRadius = 2.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.expandImageView.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.1)
        self.expandImageView.layer.cornerRadius = 2.0
        
        self.configure(self.adItem)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.adCityLabel.text = ""
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    internal func configure(adItem: Ad) {
        self.adItem = adItem
        
        var gFrame: CGRect = self.gradientLayer.frame
        gFrame.size.width = UIScreen.mainScreen().bounds.width
        self.gradientLayer.frame = gFrame
        
        self.adCityLabel.text = adItem.city
        self.mapView.setRegion(MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake(self.adItem.latitude, self.adItem.longitude), self.RegionDistance * 2, self.RegionDistance * 2), animated: false)
        self.mapView.addAnnotation(AdAnnotation(adItem: adItem))
    }
    
}
