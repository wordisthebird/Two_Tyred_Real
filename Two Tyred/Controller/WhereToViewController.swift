//
//  WhereToViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 08/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit

class WhereToViewController: UIViewController {
    
    @IBOutlet weak var EnteredTextField: UITextField!
    
    var routeType: String=""
    
    
    var placeName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
       /* if let vc =  segue.destination as? MapPageViewController{
            vc.destinationName = EnteredTextField.text
        }*/
        
    }
    
    @IBAction func GoPressed(_ sender: Any) {
        print("Boom: "+EnteredTextField.text!)
        if(1>10){

            self.placeName = EnteredTextField.text!
            
            performSegue(withIdentifier: "goToMap", sender: self)
        }
            
        else{
            print("Nope")
        }
    }
    
    
    @IBAction func longRoute(_ sender: Any) {
        
        
        performSegue(withIdentifier: "goToCategories", sender: self)
        
        
        
    }
    
    
    @IBAction func shortRoute(_ sender: Any) {
        performSegue(withIdentifier: "goToCategories", sender: self)
    }
    
    
}
