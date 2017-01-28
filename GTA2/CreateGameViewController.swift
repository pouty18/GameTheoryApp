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
    
    let gameOptions = ["Public Good", "Prisoner's Del.", "Simple Auction", "Trade Off","Public Good", "Prisoner's Del.", "Simple Auction", "Trade Off","Public Good", "Prisoner's Del.", "Simple Auction", "Trade Off","Public Good", "Prisoner's Del.", "Simple Auction", "Trade Off"]
    
    @IBAction func DismissViewButtonTapped() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gameOptions.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gameOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gameSelectionLabel.text = gameOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = gameOptions[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "NotoSans-Bold", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }

}
