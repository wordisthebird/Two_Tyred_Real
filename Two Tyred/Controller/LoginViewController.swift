//
//  LoginViewController.swift
//  Two Tyred
//
//  Created by Michael Christie on 06/11/2018.
//  Copyright © 2018 Michael Christie. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var EmaiTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: EmaiTextField.text!, password: PasswordTextField.text!) { (user, error) in
            if error != nil{
                print(error!)
            }
            else
            {
                print("Login successful")
                self.performSegue(withIdentifier: "goToMainPage", sender: self)
            }
        }
    }
}
