//
//  Ad.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import Foundation

class Ad: NSObject, NSCoding {

    static let DocumentsDirectory: NSURL = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL: NSURL = DocumentsDirectory.URLByAppendingPathComponent("ads")
    static let coderKey: String = "adDictionary"
    
    internal var id: String!
    internal var title: String!
    internal var created: String!
    internal var adDescription: String!
    internal var params: [(name: String, value: String)]!
    internal var latitude: Double!
    internal var longitude: Double!
    internal var city: String!
    internal var publisherName: String!
    internal var price: String!
    internal var photos: AdPhotos!
    
    private var adDictionaryRepresentation: [String: AnyObject]!
    
    override init() {
        super.init()
        
        self.id = ""
        self.title = ""
        self.created = ""
        self.adDescription = ""
        self.params = []
        self.latitude = 0.0
        self.longitude = 0.0
        self.city = ""
        self.publisherName = ""
        self.price = ""
        self.photos = AdPhotos()
    }
    
    convenience init(adDictionary: [String: AnyObject]) {
        self.init()
        self.adDictionaryRepresentation = adDictionary
        
        if let id: String = adDictionary["id"] as? String {
            self.id = id
        }
        
        if let title: String = adDictionary["title"] as? String {
            self.title = title
        }
        
        if let created: String = adDictionary["created"] as? String {
            self.created = created
        }
        
        if let desc: String = adDictionary["description"] as? String {
            self.adDescription = desc
        }
        
        if let params: [[String]] = adDictionary["params"] as? [[String]] {
            params.forEach {
                if $0.count == 2 {
                    self.params.append(($0.first!, $0.last!))
                }
            }
        }
        
        if let lat: String = adDictionary["map_lat"] as? String {
            self.latitude = Double(lat)!
        }
        
        if let lon: String = adDictionary["map_lon"] as? String {
            self.longitude = Double(lon)!
        }
        
        if let city: String = adDictionary["city_label"] as? String {
            self.city = city
        }
        
        if let name: String = adDictionary["user_label"] as? String {
            self.publisherName = name
        }
        
        if let price: String = adDictionary["list_label"] as? String {
            self.price = price
        }
        
        if let photos: [String: AnyObject] = adDictionary["photos"] as? [String: AnyObject] {
            self.photos = AdPhotos(photos: photos)
        } else {
            self.photos = AdPhotos()
        }
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let dictionary: [String: AnyObject] = (aDecoder.decodeObjectForKey(Ad.coderKey) as? [String: AnyObject])!
        self.init(adDictionary: dictionary)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.adDictionaryRepresentation, forKey: Ad.coderKey)
    }
    
    internal func getPhotosUrlStrings() -> [String] {
        var urlStrings: [String] = []
        self.photos.data.forEach {
            let photoUrl: String = PhotoUrlPrefix + self.photos.photosId + "_\($0.id)_\($0.width)x\($0.height)_" + self.title.stringByReplacingOccurrencesOfString(" ", withString: "-").stringByReplacingOccurrencesOfString("/", withString: "").lowercaseString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())! + "_rev\(self.photos.rev).jpg"
            urlStrings.append(photoUrl)
        }
        return urlStrings
    }
    
}
