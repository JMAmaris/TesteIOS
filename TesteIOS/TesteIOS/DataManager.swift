//
//  DataManager.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import Foundation

class DataManager {

    static let sharedInstance: DataManager = DataManager()
    
    private let domain: String = "com.domain.data"
    
    internal func getAdsList(result: ([Ad], NSError?) -> Void) {
        NetworkManager.sharedInstance.getAds { (adsDictionary: [String: AnyObject], error: NSError?) in
            if error == nil {
                if let adsArray: [[String: AnyObject]] = adsDictionary["ads"] as? [[String: AnyObject]] {
                    var ads: [Ad] = []
                    adsArray.forEach {
                        ads.append(Ad(adDictionary: $0))
                    }
                    dispatch_async(dispatch_get_main_queue(),{
                        result(ads, error)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(),{
                        result([], NSError(domain: self.domain, code: -2, userInfo: nil))
                    })
                }
            } else {
                dispatch_async(dispatch_get_main_queue(),{
                    result([], error)
                })
            }
        }
    }
    
}
