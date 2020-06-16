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
        aCoder.encode(name, forKey: "name")
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        self.init(name: name)
    }
    
    var name: String
    
    init( name: String) {
        self.name = name
    }
}
