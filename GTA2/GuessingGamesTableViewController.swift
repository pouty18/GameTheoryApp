//
//  GuessingGamesTableViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/27/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit
import Firebase


class GuessingGamesTableViewController: UITableViewController {
    
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference()
    
    var players:[GuessingGame] = playerData
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGuessingGameData()
    }

    @IBAction func doneWithTable(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            
            
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
            
            let player = players[indexPath.row] as GuessingGame
            let range = "Range: \(player.lowerBound!)-\(player.upperBound!), Multiplier: \(player.multiplier!)"
            cell.textLabel?.text = player.gameName
            cell.detailTextLabel?.text = range
            return cell
    }

    func loadGuessingGameData() {
        var newData: [GuessingGame] = [
            GuessingGame(_name: "Game1", _lowerBound: "0", _upperBound: "1000", _multiplier: 0.1, _reward: 10)]
        newData.removeAll()
        players.removeAll()
        ref.observeEventType(.Value, withBlock: { snapshot in
            
            if let postData = snapshot.value as? [String: AnyObject] {
                
                if let gamesList = postData["games"] {
                    
                    //get guessing Games

                    if let gGamesList = gamesList["guessingGames"] as? [String: AnyObject] {
                        //get individual games, and add them to the arrary

                        for child in gGamesList {
                            let tempKey = child.0
                            if let tempName = child.1["gameName"] as? String {
                                if let tempUBound = child.1["upperRange"] as? String {
                                   if let tempLBound = child.1["lowerRange"] as? String {
                                      if let tempMultiplier = child.1["multiplier"] as? String {
                                        if let tempReward = child.1["reward"] as? String {
                                            self.players.append(GuessingGame(_name: tempName, _lowerBound: tempLBound, _upperBound: tempUBound, _multiplier: Float(tempMultiplier), _reward: Int(tempReward), _key: tempKey))
                                            print("made it NIGGA")
                                            
                                        } else {
                                            print("error line 74 ")
                                        }
                                      } else {
                                        print("error line 73")
                                        }
                                   } else {
                                    print("error line 72")
                                    }
                                } else {
                                    print("error line 71")
                                }
                            } else {
                                    print("error in guard statement")
                                    return
                            }
                        }
                    } else {
                        print("Error line 65: unable to retrieve guessingGames from games")
                    }
                    
                } else {
                    print("error on line 61")
                }
                
            } else {
                print("error making snapshot json in guessingGame")
            }
            print(self.players.debugDescription)
            self.tableView.reloadData()
            
    })

}
}

