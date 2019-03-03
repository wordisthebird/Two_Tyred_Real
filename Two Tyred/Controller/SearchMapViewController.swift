//
//  SearchMapViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 03/03/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import Mapbox
import MapboxNavigation
import MapboxDirections
import MapboxCoreNavigation

class SearchMapViewController: UIViewController, MGLMapViewDelegate {
    
    
    @IBOutlet weak var musicButton: UIButton!
    
    var longCoord1: [Double] = []
    var latCoord1: [Double] = []
    var names1: [String] = []
    
    var latitudez: Double = 0
    var longitude: Double = 0
    
    var MapView : NavigationMapView!
    var TestButton : UIButton!
    var TestButton2 : UIButton!
    
    var directionsRoute: Route?
    
    var one = CLLocationCoordinate2D()
    var two = CLLocationCoordinate2D()
    var three = CLLocationCoordinate2D()
    var four = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        

        // Do any additional setup after loading the view, typically from a nib.
        MapView = NavigationMapView(frame: view.bounds)
        MapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        MapView.showsUserLocation = true
        
        MapView.delegate = self
        
        MapView.setUserTrackingMode(.follow, animated: true)
        
        view.addSubview(MapView)
        
        one.longitude = longitude
        one.latitude = latitudez
        
        view.bringSubviewToFront(musicButton)
        
        addButton()
    }
    
    func addButton(){
        TestButton = UIButton(frame: CGRect(x: (view.frame.width/2)-120, y: view.frame.height - 75, width:100, height: 50))
        TestButton.backgroundColor = UIColor.white
        TestButton.setTitle("Go", for: .normal)
        TestButton.setTitleColor(UIColor(red: 59/255, green:178/255, blue:208/255, alpha: 1), for: .normal)
        TestButton.titleLabel?.font = UIFont(name: "Avenirnext-DemiBold", size: 18)
        TestButton.layer.cornerRadius = 25
        TestButton.layer.shadowOffset = CGSize(width:0, height: 10)
        TestButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        TestButton.layer.shadowRadius = 5
        TestButton.layer.shadowOpacity = 0.3
        //TestButton.addTarget(self, action: #selector(navigateButtonPressed(_:)), for: .touchUpInside)
        TestButton.addTarget(self, action: #selector(actionWithoutParam), for: .touchUpInside)
        
        TestButton2 = UIButton(frame: CGRect(x: (view.frame.width/2)-0, y: view.frame.height - 75, width:100, height: 50))
        TestButton2.backgroundColor = UIColor.white
        TestButton2.setTitle("End", for: .normal)
        TestButton2.setTitleColor(UIColor(red: 59/255, green:178/255, blue:208/255, alpha: 1), for: .normal)
        TestButton2.titleLabel?.font = UIFont(name: "Avenirnext-DemiBold", size: 18)
        TestButton2.layer.cornerRadius = 25
        TestButton2.layer.shadowOffset = CGSize(width:0, height: 10)
        TestButton2.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        TestButton2.layer.shadowRadius = 5
        TestButton2.layer.shadowOpacity = 0.3
        //TestButton.addTarget(self, action: #selector(navigateButtonPressed(_:)), for: .touchUpInside)
        TestButton2.addTarget(self, action: #selector(actionWithoutParam2), for: .touchUpInside)
        
        MapView.addSubview(TestButton)
        MapView.addSubview(TestButton2)
        
    }
    
    @objc func actionWithoutParam(){
        
        MapView.setUserTrackingMode(.none, animated: true)
        
      
        
        calculateRoute(from: (MapView.userLocation!.coordinate), to: one) { (route, error) in
            if error != nil{
                print("boom")
            }
            else{
                print("what")
            }
        }
    }
    
    @objc func actionWithoutParam2(){
        
        let alert = UIAlertController(title: "Finished", message: "Hope you enjoyed!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                self.performSegue(withIdentifier: "goToEnd", sender: self)
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func calculateRoute(from originCorr: CLLocationCoordinate2D, to first: CLLocationCoordinate2D, completion: (Route?, Error?) -> Void) {
        
        let One1 = Waypoint(coordinate: originCorr, coordinateAccuracy: -1, name: "Current Location")
        let Two2 = Waypoint(coordinate: first, coordinateAccuracy: -1, name: "Middle")
       
        let options = NavigationRouteOptions(waypoints: [One1,Two2], profileIdentifier: .automobile)
        
        _ = Directions.shared.calculate(options, completionHandler: {(waypoints, routes, error) in
            
            self.directionsRoute = routes?.first
            //draw line
            self.Draw(route: self.directionsRoute!)
            
            //rectangle bounds
            let coordinateBounds = MGLCoordinateBounds(sw: first, ne: originCorr)
            
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            
            let routeCamera = self.MapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            
            self.MapView.setCamera(routeCamera, animated: true)
        })
        return
    }
    
    func Draw(route:Route){
        
        guard route.coordinateCount > 0 else{return}
        
        var routeCoordinates = route.coordinates!
        
        let polyline = MGLPolylineFeature(coordinates: &routeCoordinates, count: route.coordinateCount)
        
        if let source = MapView.style?.source(withIdentifier: "route-source")as? MGLShapeSource{
            source.shape = polyline
        }
        else{
            let source = MGLShapeSource(identifier: "route-source", features: [polyline], options: nil)
            
            let linestyle = MGLLineStyleLayer(identifier: "route-style", source: source)
            
            linestyle.lineWidth = NSExpression(forConstantValue: 5)
            linestyle.lineColor = NSExpression(forConstantValue: UIColor.blue)
            
            MapView.style?.addSource(source)
            MapView.style?.addLayer(linestyle)
        }
    }
    
    
    func mapView(_ mapView: MGLMapView,  annotationCanShowCallout annotation: MGLAnnotation)->Bool{
        return true
    }
    
    func mapView(_ mapView: MGLMapView, tapOnCalloutFor annotation: MGLAnnotation) {
        let navigationVC = NavigationViewController(for: directionsRoute!)
        present(navigationVC, animated: true, completion: nil)
    }
    
    
    
   
    @IBAction func appleMusicClicked(_ sender: Any) {
        
        self.performSegue(withIdentifier: "goToMusic", sender: self)
    }
    
    
    
    
}
