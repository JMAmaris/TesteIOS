//
//  AdPhotos.swift
//  TesteIOS
//
//  Created by Jorge Mendes on 25/05/16.
//  Copyright © 2016 amaris. All rights reserved.
//

import Foundation

internal let PhotoUrlPrefix: String = "https://img.olx.pt/images_olxpt/"

class AdPhotos {
    
    internal var photosId: String!
    internal var rev: Int!
    internal var data: [(id: Int, width: Int, height: Int)] = []
    
    init() {
        self.photosId = ""
        self.rev = 0
        self.data = []
    }
    
    init(photos: [String: AnyObject]) {
        if let id: Int = photos["riak_key"] as? Int {
            self.photosId = "\(id)"
        }
        
        if let rev: Int = photos["riak_rev"] as? Int {
            self.rev = rev
        }
        
        if let data: [[String: Int]] = photos["data"] as? [[String: Int]] {
            data.forEach {
                self.data.append(($0["slot_id"]!, $0["w"]!, $0["h"]!))
            }
            self.data = self.data.sort {
                return $0.id < $1.id
            }
        }
    }
    
}
