//
//  GuessingGameViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/27/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Firebase

class GuessingGameViewController: UIViewController {

    @IBOutlet weak var gameNameTxt: UITextField!
    @IBOutlet weak var lowerRangeTxt: UITextField!
    @IBOutlet weak var upperRangeTxt: UITextField!
    @IBOutlet weak var factorTxt: UITextField!
    @IBOutlet weak var rewardTxt: UITextField!

    @IBOutlet weak var rangeReviewLabel: UILabel!
    @IBOutlet weak var multiplierReviewLabel: UILabel!
    @IBOutlet weak var rewardReviewLabel: UILabel!
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    
    @IBAction func submitGuessingGame() {
        addDataToDatabase()
        presentAlertView("Game Sent")
        print("Successfully Submitted Guessing Game with details: \(presentText())")
    }
    
    
    func addDataToDatabase() {
        let childs = ref.child("guessingGames").childByAutoId()
        let key = childs.key
        let post = ["gameName": gameNameTxt.text!,
            "lowerRange": lowerRangeTxt.text!,
            "upperRange": upperRangeTxt.text!,
            "multiplier": factorTxt.text!,
            "reward": rewardTxt.text!]
        let childUpdates = ["/games/guessingGames/\(key)/" : post]
        ref.updateChildValues(childUpdates as [NSObject : AnyObject])
    }
    
    func clearFields() {
        gameNameTxt.text = ""
        lowerRangeTxt.text = ""
        upperRangeTxt.text = ""
        factorTxt.text = ""
        rewardTxt.text = ""
        rangeReviewLabel.text = ""
        multiplierReviewLabel.text = ""
        rewardReviewLabel.text = ""
    }
   

    @IBAction func updateLowerRangeLabel(sender: UITextField) {
        
        rangeReviewLabel.text = "\(sender.text!)-"
    }
    
    @IBAction func updateUpperRangeLabel(sender: UITextField) {
        let temp = rangeReviewLabel.text
        rangeReviewLabel.text = temp!+(sender.text!)
    }
   
    @IBAction func updateMultiplerLabel(sender: UITextField) {
        multiplierReviewLabel.text = sender.text
    }
    
    @IBAction func updateRewardLabel(sender: UITextField) {
        rewardReviewLabel.text = sender.text
    }
    
    func presentAlertView(str: String) {
        
        let alert = UIAlertController(title: str, message: presentText(), preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { action in
            self.clearFields() }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentText()->String {
        let str: String = ("Name: \(gameNameTxt.text), Range: \(getRange()), Multiplier: \(multiplierReviewLabel.text!), Factor: \(factorTxt.text!), Reward: \(rewardTxt.text!)")
        return str
    }
    
    func getRange() -> String {
        return "\(lowerRangeTxt.text!) - \(upperRangeTxt.text!)"
    }
    
    
}
