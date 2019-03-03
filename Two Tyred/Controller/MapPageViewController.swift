//
//  MapPageViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 08/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var destinationName: String? = nil
    var myStringValue:String?
    
    var longitude:Double = 0.0
    var lattitude:Double = 0.0
    
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var EndRideButton: UIButton!
    @IBOutlet weak var AppleMusicButton: UIButton!
    
    let geoFenceRegion:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 54.2587379170483, longitude: -8.45876879973412), radius: 1, identifier: "Home")
    
    let geoFenceRegion2:CLCircularRegion = CLCircularRegion(center: CLLocationCoordinate2D(latitude: 54.27254740886891, longitude: -8.471610720735045), radius: 1, identifier: "IT Sligo")
    
    
    //LILLIES:   54.27254740886891   -8.471610720735045
    //IT LAB:    54.2788489              -8.4573784
    
    let annotation = MKPointAnnotation()
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print("Destination name: "+destinationName!)
        
        print("THIS IS A TEST: ",longitude,"    lat: ",lattitude)
        annotation.coordinate = CLLocationCoordinate2D(latitude: 54.2787931957852, longitude: -8.457678769206437)
        
        
        MapView.addAnnotation(annotation)
        
        
        // 54.2787931957852
        //  -8.457678769206437
        
        //location you want to be monitered
        //54.27876458237029, -8.457706674336436
        
        
        //request to be allowed to use location
        locationManager.requestAlwaysAuthorization()
        
        
        //Round the button
        viewDidLayoutSubviews()
        
        //shows map
        MapView.delegate = self
        //shows scale, points of interest and location
        MapView.showsScale = true
        MapView.showsPointsOfInterest = true
        MapView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        //if map is running
        //use best locatation
        //update loacation constantly
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
        }
        
        let sourceCoordinates = locationManager.location?.coordinate
        
        //destination coordinate
        let destCoordinated = CLLocationCoordinate2DMake(longitude, lattitude)
        //current location
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinated)
        
        let sourceItem = MKMapItem(placemark: sourcePlacemark)
        let destItem = MKMapItem(placemark: destPlacemark)
        
        //let distanceInMeters = sourceCoordinates.distance(from: destCoordinated)
        
        //let distanceInMeters = sourceCoordinates.distance(from: destCoordinated) // result is in meters
        
        
        print()
        print("Distance: ")
        print()
        
        let directionRequest  = MKDirections.Request()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate(completionHandler: {
            response, error in
            
            guard let response = response else {
                if error != nil{
                    print("Something went wrong")
                }
                return
            }
            let route = response.routes[0]
            self.MapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.MapView.setRegion(MKCoordinateRegion(rekt), animated: true)
            
        })
        //tells phone to moniter for the location given
        locationManager.startMonitoring(for: geoFenceRegion)
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        self.performSegue(withIdentifier: "GoToAR", sender: self)
    }
    
    //Exited region function
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        let alert = UIAlertController(title: "There was an error?", message: "Entered", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    //entered region function
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let alert = UIAlertController(title: "Did you bring your towel?", message: "Exited.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        return renderer
    }
    
    override func viewDidLayoutSubviews(){
        EndRideButton.layer.masksToBounds = true
        EndRideButton.layer.cornerRadius = EndRideButton.frame.width/2
    }
    
    
    @IBAction func spotifyClicked(_ sender: Any) {
        print("Apple Music clicked")
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

