//
//  ViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registrationTypeLabel: UILabel!
    
    var game = GameMaster()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
            updateUserInfo()
    }
    
    func updateLabels() {
        titleLabel.text! = "\(globalUser.name)"
        emailLabel.text! = "\(globalUser.email)"
        registrationTypeLabel.text! = "\(globalUser.registrationType)"
    }
    

    @IBAction func signOutButtonTapped(sender: AnyObject) {
        titleLabel.text! = "Protected"
        emailLabel.text! = "Email"
        registrationTypeLabel.text! = "Registration Type"
        //log off user
//        hasLoaded = false
        defaults.removeObjectForKey("userName")
        defaults.removeObjectForKey("userEmail")
        defaults.removeObjectForKey("userRegistrationType")
        defaults.removeObjectForKey("successfulLogin")
        defaults.removeObjectForKey("userIsLoggedIn")
        
        globalUser = User()
        
        self.performSegueWithIdentifier("loginView2", sender: self)
    }
    
    
    //call updateUserInfo to update the the labels for the current user
    func updateUserInfo() {
        
        let urlString = "http://localhost/~richardpoutier/stap/userInfo.php"
        let url = NSURL(string: urlString)
        let session = NSURLSession.sharedSession()
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        
        let requestString = "type=getUserInfo&email="+emailLabel.text!
        
        request.HTTPBody = requestString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
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
        
        print("made it to line 97 viewController.swift")
        if let myData = defaults.objectForKey("data") as? NSData {
            print("Line 101")
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(myData, options: []) as? [String: AnyObject] {
                    print("Line 104")
                    guard let status = json["status"] as? String else {
                        print("Error finding userInfo with json:")
                        return
                    }
                    
                    if status == "Success" {
                        print("Json call was successful in viewController.swift")
                        guard let userInfo = json["userInfo"] as? [String: AnyObject] else {
                            print("error binding userInfo in viewController.swift")
                            return
                        }
                        
                        guard let userName = userInfo["name"] as? String, let userReg = userInfo["registrationType"] as? String else {
                            print("Error casting name and userReg to variables")
                            return
                        }
                        print("called userInfo.php and successfuly binded json to variables ")
                        globalUser.name = userName
                        globalUser.registrationType = userReg
                        updateLabels()
                        registrationTypeLabel.text! = userReg
                    }
                } else {
                    print("error in the serialization of json data")
                }
                
            } catch {
                print("error serializing JSON: \(error)")
            }
            
        }

    }
}

