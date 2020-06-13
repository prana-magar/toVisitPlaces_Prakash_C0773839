//
//  ViewController.swift
//  FindWay_ Prakash_C0773839
//
//  Created by Prakash on 2020-06-13.
//  Copyright © 2020 com.lambton. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add delegate
        locationManager.delegate = self
        
        // request permission
        locationManager.requestWhenInUseAuthorization()
        
        // update map info
        locationManager.startUpdatingLocation()
        
        
        // Do any additional setup after loading the view.
    }


}



// extension to add map functionalities
extension MapViewController: CLLocationManagerDelegate{
    
}

