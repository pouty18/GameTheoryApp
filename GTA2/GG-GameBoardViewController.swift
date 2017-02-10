//
//  GG-GameBoardViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/30/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Firebase

class GG_GameBoardViewController: UIViewController, UITextFieldDelegate {

    //firebase reference
    var ref = FIRDatabase.database().reference(withPath: "submissions")
    
    //gameboard properties
    var gameID: String = ""
    var authID: String = ""
    var gName: String = ""
    var range: String = ""
    var multiplier: String = ""
    var reward: String = ""
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    //attribute descriptions
    @IBOutlet weak var rgDescription: UILabel!  //for 'range'
    
    @IBOutlet weak var mDescription: UILabel!   //for 'multiplier'
    
    @IBOutlet weak var rdDescription: UILabel!  //for 'reward'
    
    //guesstextField
    @IBOutlet weak var guessTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded")
        
        guessTxt.delegate = self
        gameNameLabel.text! = gName
        rgDescription.text! = range
        rdDescription.text! = reward
        mDescription.text! = multiplier
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print("Appeared")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        gameNameLabel.text! = ""
        rgDescription.text! = ""
        rdDescription.text! = ""
        mDescription.text! = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.guessTxt.resignFirstResponder()
        return true
    }
    
    // MARK - IBActions
    
    //submit button was tapped
    @IBAction func submitGuess(_ sender: AnyObject) {
        if guessTxt.text == "" {
            presentAlertView("Error", _message: "No value entered for 'guess'")
            makeTextfieldsRed()
            guessTxt.isUserInteractionEnabled = false
        } else {
            //submit guess to Firebase
//            addDataToDatabase(guessTxt.text!)
            presentAlertView("Success", _message: "You have sucessfully sent in a response.")
            print("Submitted Guess of: \(guessTxt.text)")
            addDataToDatabase(guessTxt.text!)
            guessTxt.text = ""
//            self.dismissViewControllerAnimated(true, completion: nil)
//          guessTxt.isUserInteractionEnabled = false
            guessTxt.isEnabled = false
        }
    }
    
    @IBAction func cancelGame() {
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK - IBActions
    func addDataToDatabase(_ guess: String) {

        var maxIndex: Int = 0
        
        let post = ["guess": guess]
        var thisRound = "round-" //this needs to be dynamically changed
        var childUpdates =  [AnyHashable: Any]()

        ref.observeSingleEvent(of: .value, with: { snapshot in

            if let postData = snapshot.value as? [String: AnyObject] {

                //if let userList = postData["submissions"] {
                    
                    //get guessing GamesData
                    if let games = postData[globalAuthID] as? [String: AnyObject] {
                        if let game = games[self.gameID] as? [String: AnyObject] {
                            maxIndex = game.count
                        }
                    }
                // }
            }
            
            thisRound=("round-\(maxIndex)")
            
            childUpdates = ["/\(globalAuthID)/\(self.gameID)/\(thisRound)/" : post]
            
            self.ref.updateChildValues(childUpdates as [AnyHashable: Any])
        })

    }
    
    func getMaxNumberInList(_ list: String) -> Int {
        return 0
    }
    
    
    // MARK - Present pop up view controller
    func makeTextfieldsRed() {
        guessTxt.text!  = ""
        guessTxt.attributedPlaceholder = NSAttributedString(string: "value", attributes: [NSForegroundColorAttributeName: UIColor.red])
       
    }
    func presentAlertView(_ _title: String, _message: String) {
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

    
}
