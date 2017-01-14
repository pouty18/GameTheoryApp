//
//  RegisterPageViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Foundation

class RegisterPageViewController: UIViewController {

    @IBOutlet weak var firstNameTxt: UITextField!
    @IBOutlet weak var lastNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var verifyTxt: UITextField!
    
    var firstName: String!
    var lastName: String!
    var email: String!
    
    
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
            if (passwordTxt.text! != verifyTxt.text!) {
                passwordTxt.text! = ""
                verifyTxt.text! = ""
                passwordTxt.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                verifyTxt.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            }
            else  {
                
                //access webservice
                //                let urlString = NSURL(string: "http://localhost/~richardpoutier/stap/register-process.php")
                
                //creating NSMutableURLRequest
                //                let request = NSMutableURLRequest(URL: urlString!)
                let urlString = "http://localhost/~richardpoutier/stap/userRegister.php"
                let session = NSURLSession.sharedSession()
                let url = NSURL(string: urlString)
                let request = NSMutableURLRequest(URL: url!)
                request.HTTPMethod = "POST";
                
                //                let session = NSURLSession.sharedSession()
                //setting the method to post
                //                request.HTTPMethod = "POST"
                
                //getting values from text fields
                let emailVal = emailTxt.text!
                let name    = firstNameTxt.text! + " \(lastNameTxt.text!)"
                let pass1   = passwordTxt.text!
                let pass2   = verifyTxt.text!
                let userReg = "student"
                
                //creating the post parameter by concatenating the keys and values from text field
                let postString = "name="+name+"&email="+emailVal+"&password1="+pass1+"&password2="+pass2+"&registrationType="+userReg
                
                //adding the parameters to request body
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
                
                
//                session.dataTaskWithRequest(request) { data, response, error in
//                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
//                        print("error=\(error)")
//                        return
//                    }
                
                

                session.dataTaskWithRequest(request, completionHandler: { (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                    guard error == nil && data != nil else {                                                          // check for fundamental networking error
                        print("error=\(error)")
                        return
                    }
                    if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                        print("statusCode should be 200, but is \(httpStatus.statusCode)")
                        print("response = \(response)")
                    } else {
                        
//                        let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
                        
                        do {
                        if let data = data, json = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String: AnyObject] {
                                // Do stuff
                            defaults.setValue(name, forKey: "userName")
                            defaults.setValue(emailVal, forKey: "userEmail")
                            defaults.setValue(userReg, forKey: "userRegistrationType")
                            defaults.setValue(true, forKey: "successfulLogin")

                            print(json)
                        } else {
                            
                            }
                        
                        } catch {
                            print("error serializing JSON: \(error)")
                        }
                    }
                }).resume()
        }
         presentProtectedView()
    }
    
    @IBAction func test(sender: AnyObject) {
        print(defaults.stringForKey("wasHit"))
        print(defaults.stringForKey("successfulLogin"))
    }
    
    func presentProtectedView() {
        
        if NSUserDefaults.standardUserDefaults().boolForKey("successfulLogin") {
            self.performSegueWithIdentifier("protectedViewFromRegister", sender: nil)
            print("ChangeViews")
        }
    }

    @IBAction func returnToLoginView() {
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    func presentAlertView() {
        
        let alert = UIAlertController(title: "Message", message: presentText(), preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentText()->String {
        let str: String = ("Name: " + firstName! + " " + lastName! + ", Email " + email!)
        return str
    }

}
