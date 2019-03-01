//
//  LandingPageViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 25/02/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import Mapbox

class LandingPageViewController: UIViewController , MGLMapViewDelegate{
    
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
        let hello = MGLPointAnnotation()
        hello.coordinate = CLLocationCoordinate2D(latitude: 54.2787722, longitude: -8.457535)
        hello.title = "Hello world!"
        hello.subtitle = "Welcome to my marker"
        
        // Add marker `hello` to the map.
        mapView.addAnnotation(hello)
        
        mapView.bringSubviewToFront(RideButton)
    }
    
    // Use the default marker. See also: our view annotation or custom marker examples.
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        return nil
    }
    
    // Allow callout view to appear when an annotation is tapped.
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    override func viewDidLayoutSubviews(){
        RideButton.layer.masksToBounds = true
        RideButton.layer.cornerRadius = RideButton.frame.width/2
    }
}
