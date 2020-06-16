//
//  Place.swift
//  toVisitPlaces_ Prakash_C0773839
//
//  Created by Prakash on 2020-06-15.
//  Copyright © 2020 com.lambton. All rights reserved.
//

import Foundation
import MapKit

class Place:   NSObject, NSCoding   {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(key, forKey: "key")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let key = aDecoder.decodeObject(forKey: "key") as! String
        let latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        let longitude = aDecoder.decodeObject(forKey: "longitude") as! String

        self.init(key:key, latitude:latitude, longitude:longitude)
    }
    
    var key: String
    var latitude: String
    var longitude: String
    
    init( key: String, latitude: String, longitude: String) {
        self.key = key
        self.latitude = latitude
        self.longitude = longitude
    }
}
