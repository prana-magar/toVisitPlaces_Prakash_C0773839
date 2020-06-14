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

    
    @IBOutlet weak var carBtn: UIButton!
    @IBOutlet weak var walkingBtn: UIButton!
    var destination: CLLocationCoordinate2D!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var transportType: MKDirectionsTransportType = MKDirectionsTransportType.walking
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
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
        
        // customize buttons
        walkingBtn.layer.borderWidth = 2
        walkingBtn.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        walkingBtn.layer.cornerRadius = 20
        
        walkingBtn.layer.shadowColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 0.25)
        walkingBtn.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        walkingBtn.layer.shadowOpacity = 1.0
        walkingBtn.layer.shadowRadius = 1.0
        walkingBtn.layer.masksToBounds = false
        
       
        
        
        carBtn.layer.borderWidth = 2
       carBtn.layer.borderColor = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
       carBtn.layer.cornerRadius = 20
}

    @IBAction func displayCarRoute(_ sender: Any) {
        // remove all overlays
        transportType = .automobile
        displayRoute(transportType: .automobile)
       

        
    }
    @IBAction func displayWalkingRoute(_ sender: Any) {
        // remove all overlays
        transportType = .walking
       displayRoute(transportType: .walking)
     

    }
    @IBAction func directionBtn(_ sender: Any) {
        displayRoute(transportType: transportType)
      
    }
    
    @IBAction func minusBtn(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
       region.span.latitudeDelta *= 2.0
       region.span.longitudeDelta *= 2.0
       mapView.setRegion(region, animated: true)
    }
    @IBAction func plusBtn(_ sender: Any) {
        var region: MKCoordinateRegion = mapView.region
           region.span.latitudeDelta /= 2.0
           region.span.longitudeDelta /= 2.0
           mapView.setRegion(region, animated: true)
    }
    
    func displayRoute(transportType: MKDirectionsTransportType){
        
        if(destination == nil){
            return
        }
        
        if transportType == MKDirectionsTransportType.walking{
            carBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0)
            walkingBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.4)
        }
        else{
            carBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.4)
           walkingBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0)
        }
        
        mapView.removeOverlays(mapView.overlays)

        // add mark for source and destination
          let sourcePlaceMark = MKPlacemark(coordinate: locationManager.location!.coordinate)
          let destinationPlaceMark = MKPlacemark(coordinate: destination)
                  
          // request a direction
          let directionRequest = MKDirections.Request()
          
          // define source and destination
          directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
          directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
          
          // transportation type
          directionRequest.transportType = transportType
          
          // calculate directions
          let directions = MKDirections(request: directionRequest)
          directions.calculate { (response, error) in
              guard let directionResponse = response else {print("error"); return}
              // create route
              let route = directionResponse.routes[0]
              
              // draw the polyline
              self.mapView.addOverlay(route.polyline, level: .aboveRoads)
              
              // defining the bounding map rect
              let rect = route.polyline.boundingMapRect

              self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
          }
        
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
        
        // remove all overlays
        mapView.removeOverlays(mapView.overlays)
        
        // remove selected highlight in btn
        carBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0)
       walkingBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.0)
        
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
        destination = destinationLocation

    }
    
    func removeAllMarkers(){
        for annotation in mapView.annotations{
            mapView.removeAnnotation(annotation)
        }
    }
    
    
}


extension MapViewController: MKMapViewDelegate{
    
    //MARK: - render for overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       
        if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 3
            return rendrer
        }
        return MKOverlayRenderer()
    }
}
