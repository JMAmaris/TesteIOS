//
//  NetworkManager.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import UIKit

class NetworkManager {

    static let sharedInstance: NetworkManager = NetworkManager()
    
    private let domain: String = "com.domain.network"
    private let requestUrlString: String = "https://olx.pt/i2/ads/?json=1&search[category_id]=25"
    
    private var session: NSURLSession!
    
    private init() {
        self.session = NSURLSession.sharedSession()
    }
    
    internal func getAds(result: ([String: AnyObject], NSError?) -> Void) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        self.session.dataTaskWithRequest(NSURLRequest(URL: NSURL(string: self.requestUrlString)!)) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error == nil {
                do {
                    let jsonResult: [String: AnyObject] = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! [String: AnyObject]
                    result(jsonResult, error)
                } catch let error {
                    print(error)
                    result([:], NSError(domain: self.domain, code: -1, userInfo: nil))
                }
            } else {
                result([:], error)
            }
        }.resume()
    }
    
}
