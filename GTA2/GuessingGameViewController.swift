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
    
    
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Note that SO highlighting makes the new selector syntax (#selector()) look
        // like a comment but it isn't one
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    @IBAction func submitGuessingGame() {
        addDataToDatabase()
        presentAlertView("Game Sent")
        print("Successfully Submitted Guessing Game with details: \(presentText())")
    }
    
    
    func addDataToDatabase() {
        let childs = ref.child("games").childByAutoId()
        let key = childs.key
        let post = ["gameName": gameNameTxt.text!,
            "lowerRange": lowerRangeTxt.text!,
            "upperRange": upperRangeTxt.text!,
            "multiplier": factorTxt.text!,
            "reward": rewardTxt.text!,
            "type" : "Guessing Game"]
        let childUpdates = ["/games/\(key)/" : post]
        ref.updateChildValues(childUpdates as [AnyHashable: Any])
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
   

    @IBAction func updateLowerRangeLabel(_ sender: UITextField) {
        
        rangeReviewLabel.text = "\(sender.text!)-"
    }
    
    @IBAction func updateUpperRangeLabel(_ sender: UITextField) {
        let temp = rangeReviewLabel.text
        rangeReviewLabel.text = temp!+(sender.text!)
    }
   
    @IBAction func updateMultiplerLabel(_ sender: UITextField) {
        multiplierReviewLabel.text = sender.text
    }
    
    @IBAction func updateRewardLabel(_ sender: UITextField) {
        rewardReviewLabel.text = sender.text
    }
    
    func presentAlertView(_ str: String) {
        
        let alert = UIAlertController(title: str, message: presentText(), preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: { action in
            self.clearFields() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func presentText()->String {
        let str: String = ("Name: \(gameNameTxt.text), Range: \(getRange()), Multiplier: \(multiplierReviewLabel.text!), Factor: \(factorTxt.text!), Reward: \(rewardTxt.text!)")
        return str
    }
    
    func getRange() -> String {
        return "\(lowerRangeTxt.text!) - \(upperRangeTxt.text!)"
    }
    
    
}
