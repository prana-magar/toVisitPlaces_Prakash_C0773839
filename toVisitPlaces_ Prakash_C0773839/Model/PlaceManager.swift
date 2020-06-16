//
//  PlaceManager.swift
//  toVisitPlaces_ Prakash_C0773839
//
//  Created by Prakash on 2020-06-15.
//  Copyright © 2020 com.lambton. All rights reserved.
//

import Foundation


class PlaceManager {
    static func addPlace(place: Place){
        
        var places = getAllPlaces()
        places.append(place)
        setPlaces(places: places)
        
    }
    
    static func setPlaces(places: [Place]){
        let userDefaults = UserDefaults.standard
           let encodedData: Data =  NSKeyedArchiver.archivedData(withRootObject: places)
           userDefaults.set(encodedData, forKey: "places")
           userDefaults.synchronize()
    }
    
    
    static func removePlace(place: Place){
        var places = getAllPlaces()
        places.removeAll { (plc) -> Bool in
            plc.name == place.name
        }
        setPlaces(places: places)
    }
    
    
    static func updatePlace(placeFrom: Place, placeTo: Place){
        removePlace(place: placeFrom)
        addPlace(place: placeTo)
    }
    
    static func getAllPlaces() -> [Place]{
        let userDefaults = UserDefaults.standard
        let decoded  = userDefaults.data(forKey: "places")
        if decoded == nil{
            return [Place]()
        }
        let decodedPlaces = NSKeyedUnarchiver.unarchiveObject(with: decoded!) as! [Place]
        return decodedPlaces
    }
    
    

    
}
