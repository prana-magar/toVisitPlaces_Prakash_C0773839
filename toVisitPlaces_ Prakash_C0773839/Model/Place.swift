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
        aCoder.encode(name, forKey: "name")
        aCoder.encode(locality, forKey: "locality")
        aCoder.encode(postalCode, forKey: "postalCode")
        aCoder.encode(country, forKey: "country")

        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let key = aDecoder.decodeObject(forKey: "key") as! String
        let latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        let longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let locality = aDecoder.decodeObject(forKey: "locality") as! String
        let postalCode = aDecoder.decodeObject(forKey: "postalCode") as! String
        let country = aDecoder.decodeObject(forKey: "country") as! String

        self.init(key:key, latitude:latitude, longitude:longitude,
                  name:name,
                  locality:locality,
                  postalCode:postalCode,
                  country:country)
    }
    
    var key: String
    var latitude: String
    var longitude: String
    var name: String
    var locality: String
    var postalCode: String
    var country: String
    
    
    init( key: String, latitude: String, longitude: String,name: String, locality: String,  postalCode: String, country: String) {
        self.key = key
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.locality = locality
        self.postalCode = postalCode
        self.country = country
    }
}
