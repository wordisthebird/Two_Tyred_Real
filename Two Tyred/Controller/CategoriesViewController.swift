//
//  CategoriesViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 13/02/2019.
//  Copyright © 2019 Michael Christie. All rights reserved.
//

import UIKit
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class CategoriesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var longCoord: [Double] = []
    var latCoord: [Double] = []
    var names: [String] = []
    
    var search1:String = ""
    
    let locationName = ["Churches", "Bars and Pubs","Museums","Sports facilities"]
    
    let locationImage = [UIImage(named: "church"),UIImage(named: "pints"),UIImage(named: "museum"), UIImage(named: "sports")]
    
    let locationDescription = ["Routes around the local beautiful churches.","Routes for the locality's best pubs and restauraunts","Routes to the most interesting museums and gallaries near you", "Routes to see the localities sports facilities"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        names.removeAll()
        longCoord.removeAll()
        latCoord.removeAll()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return locationName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! CollectionViewCell
        
        cell.locationName.text = locationName[indexPath.row]
        
        cell.locationImage.image = locationImage[indexPath.row]
        
        cell.locationDescription.text = locationDescription[indexPath.row]
        
        //This creates the shadows and modifies the cards a little bit
        cell.contentView.layer.cornerRadius = 4.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("ah: ",locationName[indexPath.row])
        let Selection = locationName[indexPath.row]
        
        let lat = 54.2785726
        let long = -8.4573234
        
        convertLatLongToAddress(latitude: lat, longitude: long, selection: Selection)
        
        run(after:2){
            self.performSegue(withIdentifier: "GoMap", sender: self)
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
            
            // Street address
            // if let street = placeMark.thoroughfare {
            //  print("Street: ",street)
            // }
            
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

        
        
        
        //the general site seeing based off of location
        //let WEATHER_URL = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=things+to+do+in+\(searchQuery)&language=en&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        
        //keywords area based off of location
        //save for restaurants and pubs
        // let WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=historical+buildings+in\(searchQuery)&language=en&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        //restauraunts + bars short
        // let WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=1500&keyword=restaurants+pubs&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        
        //restauraunts + bars short
        //let WEATHER_URL2 = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=54.2785412,-8.4574523&radius=5000&keyword=pubs&key=AIzaSyDlMpFeJnAIjRNkIHwmE0y64Y2OldEgZvo"
        
        
        
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
    
}
