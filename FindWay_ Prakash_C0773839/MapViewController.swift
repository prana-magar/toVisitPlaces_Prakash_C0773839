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
        
        // register the tap guester  by user to add a pin
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(addDestinationPin))
        tapGuesture.numberOfTapsRequired = 2
        
        // add the guesture to map
        mapView.addGestureRecognizer(tapGuesture)
    }


}



// extension to add map functionalities
extension MapViewController: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        setUpMap(location: userLocation)
    }
    
    
    func setUpMap(location: CLLocation){
        
        // setup the span for map
        let latDelta: CLLocationDegrees = 0.07
        let longDelta: CLLocationDegrees = 0.07
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        
        // set up the location for center
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        // set up the region
        let region = MKCoordinateRegion(center: center, span: span)
        
        // add region to map
        mapView.setRegion(region, animated: true)

    }
    
    @objc func addDestinationPin(tapGuesture: UITapGestureRecognizer){
        
        // the touched point in the view. here its UIMapKit
        let touchPoint = tapGuesture.location(in: mapView)
        
        // get the cordinate from the touch point
        let destinationLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // add the annotaion at this point
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation
        destinationAnnotation.title = "Destination"
        
        // remove all other annotaion
        removeAllMarkers()
        
        // Add the annotation to map view
        mapView.addAnnotation(destinationAnnotation)

    }
    
    func removeAllMarkers(){
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
    }
    
    
}

