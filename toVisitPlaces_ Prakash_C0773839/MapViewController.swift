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
    
    var selectedPlace: Place?
    var editMode: Bool = false
    var destinationLocation:  CLLocationCoordinate2D!
    
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
        
        // if its edit mode render the favourite place
        
        if editMode == true{
            let destinationAnnotation = MKPointAnnotation()
            
                   
            let latitude = (selectedPlace!.latitude as NSString).doubleValue
            let longitude = (selectedPlace!.longitude as NSString).doubleValue

           destinationLocation =  CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
           destinationAnnotation.coordinate = destinationLocation
           
           // remove all other annotaion
           removeAllMarkers()
           
           
           // Add the annotation to map view
           mapView.addAnnotation(destinationAnnotation)
           destination = destinationLocation
            
            self.setUpMap(location: CLLocation(latitude: latitude, longitude: longitude)  )

            
        }
       
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
        
        if editMode == true{
            return
        }
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
        
        if editMode == true {
            let alertController = UIAlertController(title: "You can edit by dragging the pin", message: "", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel)
               alertController.addAction(cancelAction)
               present(alertController, animated: true, completion: nil)
            
            return
        }
            
        
        // remove all overlays
        mapView.removeOverlays(mapView.overlays)
        
        // remove selected highlight in btn
        carBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0)
       walkingBtn.backgroundColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.0)
        
        // the touched point in the view. here its UIMapKit
        let touchPoint = tapGuesture.location(in: mapView)
        
        // get the cordinate from the touch point
        destinationLocation = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        // add the annotaion at this point
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation
        destinationAnnotation.title = "Add to Favourite"
        
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
    
    // MARK: view for annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        if annotation is MKUserLocation {
                   return nil
               }
        
        let pinAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "droppablePin") ?? MKPinAnnotationView()
        pinAnnotation.image = UIImage(named: "ic_place_3x")
        pinAnnotation.canShowCallout = true
        
        if editMode == true{
             pinAnnotation.isDraggable = true
        }
        
        pinAnnotation.rightCalloutAccessoryView = UIButton(type: .contactAdd)
        return pinAnnotation
    }
    
    func getPlaceObj(lat : CLLocationDegrees, long : CLLocationDegrees) -> Place? {

        var place: Place?
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lat, longitude: long)){
            
            placemark, error in
            
            
            if let error = error as? CLError
            {
                print("CLError:", error)
                return
            }
                
            else if let placemark = placemark?[0]
            {
                        
                
                var placeName = ""
                var city = ""
                var postalCode = ""
                var country = ""
                if let name = placemark.name { placeName += name }
                if let locality = placemark.subLocality { city += locality }
                if let code = placemark.postalCode { postalCode += code }
                if let countryName = placemark.country { country += countryName }
                
                place = Place(key: String(lat)+":"+String(long), latitude: String(lat), longitude: String(long), name: placeName, locality: city, postalCode: postalCode, country: country)
                
             }
            
        }
        return place

    }
    
    //MARK: - callout accessory control tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        // get geo info
        
        
        let alertController = UIAlertController(title: "Success", message: "Added to Favourite list", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: self.destination.latitude, longitude: self.destination.longitude)){
                
                placemark, error in
                
                
                if let error = error as? CLError
                {
                    print("CLError:", error)
                    return
                }
                    
                else if let placemark = placemark?[0]
                {
                            
                    
                    var placeName = ""
                    var city = ""
                    var postalCode = ""
                    var country = ""
                    if let name = placemark.name { placeName += name }
                    if let locality = placemark.subLocality { city += locality }
                    if let code = placemark.postalCode { postalCode += code }
                    if let countryName = placemark.country { country += countryName }
                    
                    var place = Place(key: String(self.destination.latitude)+":"+String(self.destination.latitude), latitude: String(self.destination.latitude), longitude: String(self.destination.longitude), name: placeName, locality: city, postalCode: postalCode, country: country)
                    
                    PlaceManager.addPlace(place: place)
                    self.navigationController?.popToRootViewController(animated: true)

                    
                 }
                
            }
            
            
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
   
    
    //MARK: - render for overlay
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
       
        if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 3
            
            if(transportType == MKDirectionsTransportType.walking){
                rendrer.lineWidth = 8
                rendrer.lineDashPattern = [0, 10]
            }
            
            return rendrer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending{
            let droppedAt = view.annotation?.coordinate
            
            let lat = droppedAt?.latitude
            
            let long = droppedAt?.longitude
            
            destination = droppedAt

            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: self.destination.latitude, longitude: self.destination.longitude)){
                
                placemark, error in
                
                
                if let error = error as? CLError
                {
                    print("CLError:", error)
                    return
                }
                    
                else if let placemark = placemark?[0]
                {
                            
                    
                    var placeName = ""
                    var city = ""
                    var postalCode = ""
                    var country = ""
                    if let name = placemark.name { placeName += name }
                    if let locality = placemark.subLocality { city += locality }
                    if let code = placemark.postalCode { postalCode += code }
                    if let countryName = placemark.country { country += countryName }
                    
                    let place = Place(key: String(self.destination.latitude)+":"+String(self.destination.latitude), latitude: String(self.destination.latitude), longitude: String(self.destination.longitude), name: placeName, locality: city, postalCode: postalCode, country: country)
                    
                    PlaceManager.updatePlace(placeFrom: self.selectedPlace!, placeTo: place)
                    
                    self.selectedPlace = place
                 }
                
            }
            
        }
    }
}
