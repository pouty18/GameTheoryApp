//
//  LoginViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!

    @IBOutlet weak var passwordTxt: UITextField!
    
    @IBAction func loginButtonTapped(sender: AnyObject) {
        
        //if text fields are empty
        
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            
            //red place holders


            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        }
            
        else  {
            
            let email   = emailTxt.text!
            let pass1   = passwordTxt.text!
            
            let urlString = "http://localhost/~richardpoutier/stap/userLogin.php"
            let session = NSURLSession.sharedSession()
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "POST";
            
            let postString = "email="+email+"&password="+pass1
            
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)

            
            session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                guard error == nil && data != nil else {                                                          // check for fundamental networking error
                    print("error=\(error)")
                    return
                }
                
                if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                } else {
                    
                    
                    do {
                        if let data = data, json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                            // Do stuff
                            print(json)
                            
                            if let status = json["status"] as? [String: AnyObject] {
                                defaults.setValue(status, forKey: "successfulLogin")
                                defaults.setBool(true, forKey: "userIsLoggedIn")
                            }
                            
                            if let item = json["userInfo"] as? [String: AnyObject] {
                                if let userName = item["name"] as? [String: AnyObject], let userEmail = item["email"] as? [String: AnyObject], let userReg = item["registrationType"] as? [String: AnyObject] {
                                    
                                    defaults.setValue(userName, forKey: "userName")
                                    defaults.setValue(userEmail, forKey: "userEmail")
                                    defaults.setValue(userReg, forKey: "userRegistrationtype")
                                }
                            }
                            

                            print(json)
                        } else {
                            
                        }
                        
                    } catch {
                        print("error serializing JSON: \(error)")
                    }
                }
                
                
            }).resume()
           
        }
    
//        globalUser.printDetails()
        if defaults.boolForKey("userIsLoggedIn") == true {
            self.performSegueWithIdentifier("protectedView", sender: nil)
        } else {
            print("Error Logging in User")
            presentAlertView("Error Logging In", _message: "Problem with login creddentials")
            emailTxt.text! = ""
            passwordTxt.text! = ""
            emailTxt.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])

        }
        
    }

    func presentAlertView(_title: String, _message: String) {
    
    let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
}

func presentText()->String {
    let str = "Sucessfully logged in."
    return str
}

}
