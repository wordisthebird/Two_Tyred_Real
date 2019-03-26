//
//  MapsViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 25/02/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//


import UIKit
import Mapbox
import MapboxNavigation
import MapboxDirections
import MapboxCoreNavigation
import UserNotifications
import CoreLocation

class MapsViewController: UIViewController, MGLMapViewDelegate, CLLocationManagerDelegate{
    
    let locationManager:CLLocationManager = CLLocationManager()
    
    @IBOutlet weak var AppleMusic: UIButton!
    
    var longCoord1: [Double] = []
    var latCoord1: [Double] = []
    var names1: [String] = []
    
    var MapView : NavigationMapView!
    var TestButton : UIButton!
    var TestButton2 : UIButton!
    
    var number: Int = 0
    
    @IBOutlet weak var MusicButton: UIButton!
    
    
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
        
        
        
        let bike2 = MGLPointAnnotation()
        bike2.coordinate = CLLocationCoordinate2D(latitude: 54.277820744023046, longitude: -8.460472042352196)
        bike2.title = "AR"
        
        
        
        // Initialize and add the point annotation.
        let pisa = MGLPointAnnotation()
        pisa.coordinate = CLLocationCoordinate2D(latitude: 43.72305, longitude: 10.396633)
        pisa.title = "Leaning Tower of Pisa"
        MapView.addAnnotation(pisa)
        
        
        
        MapView.addAnnotation(bike2)
        
        MGLMapPointMake(54.277820744023046, -8.460472042352196, 5)
        
        
        view.bringSubviewToFront(MusicButton)
        
        one.longitude = longCoord1[0]
        one.latitude = latCoord1[0]
        
        two.longitude = longCoord1[1]
        two.latitude = latCoord1[1]
        
        three.longitude = longCoord1[2]
        three.latitude = latCoord1[2]
        
        four.longitude = longCoord1[3]
        four.latitude = latCoord1[3]
        
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        //explanation
        //https://stackoverflow.com/questions/23866097/ios-geofence-clcircularregion-monitoring-locationmanagerdidexitregion-does-not
        
        let geofenceRegionCenter = CLLocationCoordinate2DMake(54.2704304, -8.4736048);
        let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 15, identifier: "Lady Erin");
        geofenceRegion.notifyOnExit = true;
        geofenceRegion.notifyOnEntry = true;
        self.locationManager.startMonitoring(for: geofenceRegion)
        
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
        
        let annotationOne = MGLPointAnnotation()
        annotationOne.coordinate = one
        let newString1 = names1[0].replacingOccurrences(of: "+", with: " ", options: .literal, range: nil)
        annotationOne.title = newString1
        
        let annotationTwo = MGLPointAnnotation()
        annotationTwo.coordinate = two
        let newString2 = names1[1].replacingOccurrences(of: "+", with: " ", options: .literal, range: nil)
        annotationTwo.title = newString2
        
        let annotationThree = MGLPointAnnotation()
        annotationThree.coordinate = three
        let newString3 = names1[2].replacingOccurrences(of: "+", with: " ", options: .literal, range: nil)
        annotationThree.title = newString3
        
        let annotationFour = MGLPointAnnotation()
        annotationFour.coordinate = four
        let newString4 = names1[3].replacingOccurrences(of: "+", with: " ", options: .literal, range: nil)
        annotationFour.title = newString4
        
        MapView.addAnnotation(annotationOne)
        MapView.addAnnotation(annotationTwo)
        MapView.addAnnotation(annotationThree)
        MapView.addAnnotation(annotationFour)
        
        calculateRoute(from: (MapView.userLocation!.coordinate), to: one, to: two, to: three, to: four) { (route, error) in
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
    
    
    func calculateRoute(from originCorr: CLLocationCoordinate2D, to first: CLLocationCoordinate2D, to second: CLLocationCoordinate2D, to third: CLLocationCoordinate2D, to fourth: CLLocationCoordinate2D, completion: (Route?, Error?) -> Void) {
        
        let One1 = Waypoint(coordinate: originCorr, coordinateAccuracy: -1, name: "Current Location")
        let Two2 = Waypoint(coordinate: first, coordinateAccuracy: -1, name: "Middle")
        let Three3 = Waypoint(coordinate: second, coordinateAccuracy: -1, name: "Destination")
        let Four4 = Waypoint(coordinate: third, coordinateAccuracy: -1, name: "Destination")
        let Five5 = Waypoint(coordinate: fourth, coordinateAccuracy: -1, name: "Destination")
        
        let options = NavigationRouteOptions(waypoints: [One1,Two2,Three3,Four4,Five5], profileIdentifier: .automobile)
        
        _ = Directions.shared.calculate(options, completionHandler: {(waypoints, routes, error) in
            
            self.directionsRoute = routes?.first
            //draw line
            self.Draw(route: self.directionsRoute!)
            
            //rectangle bounds
            let coordinateBounds = MGLCoordinateBounds(sw: third, ne: originCorr)
            
            let insets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            
            let routeCamera = self.MapView.cameraThatFitsCoordinateBounds(coordinateBounds, edgePadding: insets)
            
            self.MapView.setCamera(routeCamera, animated: true)
        })
        return
    }
    
    func Draw(route:Route){
        
        number = 1
        
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
        
        if (number == 0 )
        {
            let alert = UIAlertController(title: "Slight Problem", message: "Plesse confirm ride by pressing 'Go' button.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            
        }
        else{
            let navigationVC = NavigationViewController(for: directionsRoute!)
            present(navigationVC, animated: true, completion: nil)
        }
    }
    
    
    
    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {
        
        if (annotation.title == "AR"){
            print("AR")
            self.performSegue(withIdentifier: "goToAR_Real", sender: self)
        }
        
    }
    
    @IBAction func AppleMusicClicked(_ sender: Any) {
        
        print("Boom")
        
        self.performSegue(withIdentifier: "GoToMusic", sender: self)
    }
    
    
    //entered
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered")
        
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        
        content.title = "Scan AR image"
        content.body = "Find and scan image to learn more about what you have just passed!"
        content.sound = UNNotificationSound.default
        
        content.threadIdentifier = "local-notifications temp"
        
        let date  = Date(timeIntervalSinceNow: 1)
        
        let datecomponents = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: datecomponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil{
                print("ERROR: ",error as Any)
            }        }
    }
    
    //exited
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited")
        let alert = UIAlertController(title: "Exited?", message: "Exited.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}
