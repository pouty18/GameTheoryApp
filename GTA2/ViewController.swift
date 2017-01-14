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
        goToLoginPage(false)
    }
    
    func goToLoginPage(value: Bool) {
        if value {
//            hasLoaded = false
            self.performSegueWithIdentifier("loginView", sender: self)
        } else {
            if let name = defaults.stringForKey("userName") {
                titleLabel.text! = "Welcome \(name)"
            }
            if let email = defaults.stringForKey("userEmail") {
                emailLabel.text! = "\(email)"
            }
            if let reg = defaults.stringForKey("userRegistrationType") {
                registrationTypeLabel.text! = "\(reg)"   
            }
        }
        
    }
    
    func setValues(name: String, email: String, regType: String){
        titleLabel.text! = "Welcome, " + name
        emailLabel.text! = email
        registrationTypeLabel.text! = regType
        
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
        self.performSegueWithIdentifier("loginView2", sender: self)
    }
}

