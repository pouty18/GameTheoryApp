//
//  LoginViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class LoginViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        defaults.removeObjectForKey("loginSuccess")
    }
    
    @IBOutlet weak var emailTxt: UITextField!
    
    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBAction func loginButtonTapped(_ sender: AnyObject) {
        //if text fields are empty
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //red place holders
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.red])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.red])
        }
        else {
            logInUser()
        }
    }
    
    func presentAlertView(_ _title: String, _message: String) {
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentText()->String {
        let str = "Sucessfully logged in."
        return str
    }
    
    func logInUser() {
        let email   =
            emailTxt.text!
        let pass1   = passwordTxt.text!
        
        FIRAuth.auth()?.signIn( withEmail: email, password: pass1) { (user, error) in
            // ...
            if error == nil {
                //                        self.labelMessage.text = "You are successfully registered"
                print("You have successfully logged in")
                self.performSegue(withIdentifier: "protectedView", sender: nil)
            }else{
                //                        self.labelMessage.text = "Registration Failed.. Please Try Again"
                print ("Sign-in Failed... Please Try Again")
            }
            
        }
     

    }
    
}
