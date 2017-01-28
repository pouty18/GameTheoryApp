//
//  RegisterPageViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var verifyTxt: UITextField!
    
    var firstName: String!
    var lastName: String!
    var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        globalUser.isLoggedIn = false
    }
    
    override func viewDidAppear(animated: Bool) {
        globalUser.isLoggedIn = false
    }
    
    
    @IBAction func registerButtonTapped(sender: AnyObject) {
        firstName = firstNameTxt.text!
        lastName = lastNameTxt.text!
        email = emailTxt.text!
        //if text fields are empty
        
        if firstNameTxt.text!.isEmpty || lastNameTxt.text!.isEmpty || emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty || verifyTxt.text!.isEmpty {
            
            //red place holders
            firstNameTxt.attributedPlaceholder = NSAttributedString(string: "First Name", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            lastNameTxt.attributedPlaceholder = NSAttributedString(string: "Last Name", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            verifyTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
            
        else    //make sure the two passwords are the same
            if (passwordTxt.text! != verifyTxt.text! || passwordTxt.text!.characters.count <= 5) {
                passwordTxt.text! = ""
                verifyTxt.text! = ""
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                verifyTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            }
            else  {
                //getting values from text fields
                let email = emailTxt.text!
                let password   = passwordTxt.text!
                
                FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user: FIRUser?, error) in
                    if error == nil {
//                        self.labelMessage.text = "You are successfully registered"
                        print  ("You are successfully registered")
                        
                        let changeRequest = FIRAuth.auth()?.currentUser?.profileChangeRequest()
                        changeRequest?.displayName = self.firstName+" "+self.lastName
                        changeRequest?.commitChangesWithCompletion({ (error) in
                            // ...
                            if error == nil {
                                print("Name updated")
                                self.performSegueWithIdentifier("protectedViewFromRegister", sender: nil)
                            }
                            else {
                                print("Error updating the name")
                            }
                        })
                        
                    }else{
//                        self.labelMessage.text = "Registration Failed.. Please Try Again"
                        print ("Registration Failed... Please Try Again")
                    }
                    
                })
                // ...
        }
    }
    
    func presentProtectedView() {
        
        if globalUser.isLoggedIn {
            self.performSegueWithIdentifier("protectedViewFromRegister", sender: nil)
            print("ChangeViews")
        }
        else {
            presentAlertView("A User with that account already exists")
            print("Didn't work")
        }
    }

    @IBAction func returnToLoginView() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    func makeTextfieldsRed() {
        emailTxt.text!  = ""
        passwordTxt.text! = ""
        verifyTxt.text! = ""
        emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        verifyTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
    }
    func presentAlertView(str: String) {
        
        let alert = UIAlertController(title: str, message: presentText(), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { action in
        self.makeTextfieldsRed() }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentText()->String {
        let str: String = ("Name: " + firstName! + " " + lastName! + ", Email " + email!)
        return str
    }

}
