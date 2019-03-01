//
//  RegisterViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 06/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func MakeAccount(_ sender: Any) {
        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!) { (user, error) in
            
            if error != nil
            {
                print(error!)
            }
                
            else
            {
                //success
                print("Registration Successful!")
                self.performSegue(withIdentifier: "goToMainPage", sender: self)
            }
        }
    }
}
