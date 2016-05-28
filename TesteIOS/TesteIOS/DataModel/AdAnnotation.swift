//
//  AdAnnotation.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 27/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit
import MapKit

class AdAnnotation: NSObject, MKAnnotation {

    internal var title: String?
    internal var coordinate: CLLocationCoordinate2D
    
    init(adItem: Ad) {
        self.title = adItem.title
        self.coordinate = CLLocationCoordinate2DMake(adItem.latitude, adItem.longitude)
        
        super.init()
    }
    
}
