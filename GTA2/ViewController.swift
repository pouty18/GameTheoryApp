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
    
    var ref: FIRDatabaseReference!
    
    var items: [String] = ["We", "Heart", "Swift"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //attempt to get user info
        if let user = FIRAuth.auth()?.currentUser {
            if let name = user.displayName {
                self.titleLabel.text = name
            }
            if let email = user.email {
                self.emailLabel.text = email
            }
            self.registrationTypeLabel.text = "Student"
            
            let thisID = user.uid
            globalAuthID = thisID
            
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
            updateUserInfo()
    }

    
    func updateLabels() {
        titleLabel.text! = "\(globalUser.name)"
        emailLabel.text! = "\(globalUser.email)"
        registrationTypeLabel.text! = "\(globalUser.registrationType)"
    }
    

    @IBAction func signOutButtonTapped(_ sender: AnyObject) {
        
        //log off user
        
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            globalAuthID = ""
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        globalUser = User()
        
        self.performSegue(withIdentifier: "loginView2", sender: self)
    }
    
    
    //call updateUserInfo to update the the labels for the current user
    func updateUserInfo() {
        
        
    }
}

