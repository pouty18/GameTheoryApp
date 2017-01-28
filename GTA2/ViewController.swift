//
//  ViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import Firebase
import UIKit


class ViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var registrationTypeLabel: UILabel!
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
        
    var items: [String] = ["We", "Heart", "Swift"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //attempt to get user info
        FIRAuth.auth()?.addAuthStateDidChangeListener( { (auth, user) in
            // ...
            if (user?.displayName != nil) {
                self.titleLabel.text = user?.displayName
            } else {
                self.titleLabel.text = "User-Name"
            }
            if (user?.email != nil) {
                self.emailLabel.text = user?.email
            }
            self.registrationTypeLabel.text = "Student"
        })
        
        

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
            updateUserInfo()
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    @IBAction func testButtonPressed(sender: AnyObject) {
        self.ref.child("users").childByAutoId().setValue(["username": self.titleLabel.text!+" pressed testButton"])
        print("Test button pushed")
    }
    
    //---------------------------------------------------------------------------------------------------------------------------------------------------------
    
    func updateLabels() {
        titleLabel.text! = "\(globalUser.name)"
        emailLabel.text! = "\(globalUser.email)"
        registrationTypeLabel.text! = "\(globalUser.registrationType)"
    }
    

    @IBAction func signOutButtonTapped(sender: AnyObject) {
        if (titleLabel.text! == "" || emailLabel.text! == "" || registrationTypeLabel.text! == "" ) {
            
        } else {
//            titleLabel.text! = ""
//            emailLabel.text! = ""
//            registrationTypeLabel.text! = ""
        }
        //log off user
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        globalUser = User()
        
        self.performSegueWithIdentifier("loginView2", sender: self)
    }
    
    
    //call updateUserInfo to update the the labels for the current user
    func updateUserInfo() {
        
        
    }
}

