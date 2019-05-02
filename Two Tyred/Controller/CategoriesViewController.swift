//
//  CategoriesViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 13/02/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var RouteButton: UIButton!
    
    @IBOutlet weak var collectionsView: UICollectionView!
    
    var longCoord: [Double] = []
    var latCoord: [Double] = []
    var names: [String] = []
    
    var search1:String = ""
    
    var counter: Int = 0
    var locations: [String] = []
    let Burgers = ["Churches","Pubs","Culture","Sports"]
    let burgerImages = [UIImage(named: "church"),UIImage(named: "pints"),UIImage(named: "museum"), UIImage(named: "sports")]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionsView.dataSource = self
        collectionsView.delegate = self
        
        
        collectionsView.allowsMultipleSelection = true
        let layout = self.collectionsView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.sectionInset = UIEdgeInsets(top: 0,left: 5,bottom: 0,right: 5)
        
        layout.minimumInteritemSpacing = 5
        
        layout.itemSize = CGSize(width: (self.collectionsView.frame.width - 20)/2, height: (self.collectionsView.frame.size.height/3))
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) ->Int{
        return Burgers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        cell.hamburgerLabel.text = Burgers[indexPath.item]
        
        cell.hamburgerImage.image = burgerImages[indexPath.item]
        
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.borderWidth = 0.5
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
        
        print(Burgers[indexPath.item])
        
        locations.append(Burgers[indexPath.item])
        
        counter+=1
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
        
        counter-=1
        locations.removeAll { $0 == Burgers[indexPath.item] }
    }
    
    @IBAction func CreateRoute(_ sender: Any) {
        if(counter > 2 || counter <= 0 ){
            
            let alert = UIAlertController(title: "Hey!", message: "You can only select two categories", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        else{
            print()
            for x in locations{
                print("This is it: "+x)
            }
            
            let Selection = locations[0]
            
            let lat = 54.2785726
            let long = -8.4573234
            
            convertLatLongToAddress(latitude: lat, longitude: long, selection: Selection)
            
            run(after:2){
                self.performSegue(withIdentifier: "GoMap", sender: self)
            }
        }
    }
    
    func run(after seconds: Int, completion: @escaping () -> Void){
        let deadline  = DispatchTime.now() + .seconds(seconds)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            completion()
        }
    }
    
    func convertLatLongToAddress(latitude:Double,longitude:Double, selection:String){
        let Selection = selection
        
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        var city1 = "",country1:String = ""
        var search:String = ""
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            
            // City
            if let city = placeMark.locality {
                //print("city: ",city)
                city1 = city
            }
            
            // Country
            if let country = placeMark.country {
                country1 = country
                
                search = city1+"+"+country1
                
                self.search1 = search
                
                self.getWeatherData(searchQuery: self.search1, selection: Selection)
            }
        })
    }
    
    func getWeatherData(searchQuery: String, selection: String) {
        
        print("Search query: "+searchQuery)
        print()
        
        let Selection = selection
        var WEATHER_URL2 : String = ""
        //let someCharacter: locationName[indexPath.row]
        switch Selection {
        case "Churches":
            WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=5000&keyword=churches&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        case "Bars and Pubs":
            WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=5000&keyword=pubs&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        case "Museums":
            WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=5000&keyword=museums&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        case "Sports facilities":
            WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=5000&keyword=sports+stadium&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
            
        default:
            print("Problem")
        }
        
        
       
        Alamofire.request(WEATHER_URL2).responseJSON {
            
            response in
            
            if response.result.isSuccess {
                
                let weatherJSON : JSON = JSON(response.result.value!)
                //print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    func updateWeatherData(json : JSON){
        
        var results: [String] = []
        
        var i = 0
        while i <= 4
        {
            var element:String
            let tempResult = json["results"][i]["name"]
            
            
            if tempResult != JSON.null{
                element = tempResult.string!
                results += [element]
                i = i + 1
            }
            else{
                break
            }
        }
        
        if i == 0
        {
            print("no results")
        }
        print()
        for t in results {
            //print("T: ",t)
            
            convertAddressToLatLong(placename:t)
        }
        print()
    }
    
    func convertAddressToLatLong(placename: String) {
        
        let newString = placename.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        
        print(newString)
        
        Alamofire.request("https://maps.googleapis.com/maps/api/geocode/json?address=+\(newString)+Sligo,+Ireland&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo").responseJSON {
            
            response in
            
            if response.result.isSuccess
            {
                let json : JSON = JSON(response.result.value!)
                
                let x = json["results"][0]["geometry"]["location"]["lat"].doubleValue
                let y = json["results"][0]["geometry"]["location"]["lng"].doubleValue
                
                print("latitude: ",x,", ","Long: ",y)
                
                self.doSomething(lat: x ,long: y, name: newString)
            }
                
            else
            {
                print("Error \(String(describing: response.result.error))")
            }
            
        }
        
        
    }
    
    private func doSomething(lat:Double,long: Double, name:String ) {
        //Do whatever you want with latLong
        
        latCoord += [lat]
        longCoord += [long]
        names += [name]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! MapsViewController
        
        
        
        vc.longCoord1 = self.longCoord
        vc.latCoord1 = self.latCoord
        vc.names1 = self.names
    }
    

    
    override func viewDidLayoutSubviews(){
        
        RouteButton.layer.masksToBounds = true
        RouteButton.layer.cornerRadius = RouteButton.frame.width/2
    }
}

