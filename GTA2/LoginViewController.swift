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
        var loginSuccessful = Bool()
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
                    
                    if let data = data {
                        defaults.setValue(data, forKey: "data")
                        defaults.synchronize()
                    }
                }
            }).resume()
            
            
            if let myData = defaults.objectForKey("data") as? NSData {
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(myData, options: []) as? [String: AnyObject] {
                        print(json.debugDescription)
                        guard let loginStatus = json["status"] as? String else {
                            print("Error finding userInfo with json:")
                            return
                        }
                        if loginStatus == "Success" {
                            defaults.setBool(true, forKey: "loginSuccess")
                            defaults.synchronize()
                        }
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
            }
           print("Login Successful \(defaults.boolForKey("loginSuccess"))")
            if defaults.boolForKey("loginSuccess") {
                globalUser.isLoggedIn = true
                globalUser.email = emailTxt.text!
            }
        }
    
        
//        globalUser.printDetails()
        
        if globalUser.isLoggedIn {
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
