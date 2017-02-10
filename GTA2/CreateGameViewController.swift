//
//  CreateGameViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/26/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate  {
    
    @IBOutlet weak var gamePicker: UIPickerView!
    @IBOutlet weak var gameSelectionLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    let gameOptions = ["Guessing Game", "Simultaneous Game #1", "Simultaneous Game #2", "Player Coordinated","Market Game", "Incomplete Info", "Private Value Auction", "Simple Simultaneous Move","Common Value Auction", "Public Good Game", "Sequential Bargaining", "Coin Game","Coalition Game"]
    
    @IBAction func DismissViewButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameSelectionLabel.text = gameOptions[0]
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gameOptions.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gameOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gameSelectionLabel.text = gameOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = gameOptions[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "NotoSans-Bold", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
    }

    @IBAction func createNewGame() {
        switch gameSelectionLabel.text! {
        case "Guessing Game":
            print("trying to create a new guessing game")
            break
        case "Simultaneous Game #1":
            print("Trying to create a Simultaneous Game #1 game")
            break
        case "Simultaneous Game #2":
            print("Trying to create a Simultaneous Game #2 game")
            break
        case "Player Coordinated":
            print("Trying to create a Player Coordinated game")
            break
        case "Market Game":
            print("Trying to create a Market Game game")
            break
        case "Incomplete Info":
            print("Trying to create a Incomplete Info game")
            break
        case "Private Value Auction":
            print("Trying to create a Private Value Auction game")
            break
        case "Simple Simultaneous Move":
            print("Trying to create a Simple Simultaneous Move game")
            break
        case "Common Value Auction":
            print("Trying to create a Common Value Auction game")
            break
        case "Public Good Game":
            print("Trying to create a Public Good Game game")
            break
        case "Sequential Bargaining":
            print("Trying to create a Sequential Bargaining game")
            break
        case "Coin Game":
            print("Trying to create a Coin Game game")
            break
        case"Coalition Game":
            print("Trying to create a Coalition Game  game")
            break
        default:
            break
        }
    }
    
}
