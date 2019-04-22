//
//  MainPageViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 07/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import Firebase
import Mapbox

class MainPageViewController: UIViewController, MGLMapViewDelegate{
    
   
    @IBOutlet weak var mapView: MGLMapView!
    
    @IBOutlet weak var RideButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let mapView = MGLMapView(frame: view.bounds)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Set the map’s center coordinate and zoom level.
        mapView.setCenter(CLLocationCoordinate2D(latitude: 54.2787722, longitude: -8.457535), zoomLevel: 15, animated: false)
        view.addSubview(mapView)
        
        // Set the delegate property of our map view to `self` after instantiating it.
        mapView.delegate = self
        
        // Declare the marker `hello` and set its coordinates, title, and subtitle.
        let bike1 = MGLPointAnnotation()
        bike1.coordinate = CLLocationCoordinate2D(latitude: 54.27844237284597, longitude: -8.457122002582766)
        bike1.title = "Bike"
        
        let bike2 = MGLPointAnnotation()
        bike2.coordinate = CLLocationCoordinate2D(latitude: 54.278013311378274, longitude: -8.45756644383073)
        bike2.title = "Bike"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(bike1)
        mapView.addAnnotation(bike2)
        
        mapView.bringSubviewToFront(RideButton)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        print("Hello")
        performSegue(withIdentifier: "goToQR", sender: self)
        return true
    }
    
    
   
    
    override func viewDidLayoutSubviews(){
        RideButton.layer.masksToBounds = true
        RideButton.layer.cornerRadius = RideButton.frame.width/2
    }
    
    
    
    @IBAction func logout(_ sender: Any) {
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        // this may be blank
    }
    
}
