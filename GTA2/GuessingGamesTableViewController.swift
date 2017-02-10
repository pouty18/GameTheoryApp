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
    
    var ref = FIRDatabase.database().reference(withPath: "games")
    
    var players:[GuessingGame] = playerData
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGuessingGameData()
    }

    override func tableView(_ tableView: UITableView, commit commitEditingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print("Delete called")
        if commitEditingStyle == UITableViewCellEditingStyle.delete {
            print("hit if statement")
            let gameItem = players[indexPath.row]
            ref.child("/games/guessingGames/\(gameItem.key)").removeValue { (error, ref) in
                if error != nil {
                    print("error \(error)")
                }
                self.loadGuessingGameData()
            }
            
            //**NEED TO MAKE IT SO IT DELETES ALL RECORDS OF THE GAME FOR *ALL* USERS
            ref.observeSingleEvent(of: .value, with: { snapshot in
                
                if let postData = snapshot.value as? [String: AnyObject] {
                    
                    //userList is the list of user's that have submitted any game data
                    if let userList = postData["submissions"] as? [String : AnyObject] {

                        //a user is a single user within that list who has submitted data
                        for user in userList {
                            print("Check user: \(user.0)")
                            if let gameList = user.1 as? [String : AnyObject] {
                                
                                for game in gameList {
                                    if game.0 == gameItem.key {
                                        //this game is being deleted
                                        //delete the submission records of it 
                                        //from the users
                                        print("Delete game: \(gameItem.gameName!) : \(gameItem.key)")
                                        self.ref.child("/submissions/\(user.0)/\(game.0)/").removeValue()
                                    }
                                }
                            } else {
                                print("problem in if let gameList = user.1 as? [String:AnyObject]")
                            }
                            print("")
                        }
                    }
                }
            })
            
        }
    }

    @IBAction func doneWithTable(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)  -> UITableViewCell {
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
            
            let player = players[indexPath.row] as GuessingGame
            let range = "Range: \(player.lowerBound!)-\(player.upperBound!), Multiplier: \(player.multiplier!)"
            cell.textLabel?.text = player.gameName
            cell.detailTextLabel?.text = range
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // *** Here we want to add in to the database that our current user selected to play this game
        // add to table 'Active Games' - List of all players and the games they are playing

        self.performSegue(withIdentifier: "GGGameBoard", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GGGameBoard" {
            
            if let viewcontroller = segue.destination as? GG_GameBoardViewController {
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedGame = players[indexPath.row]
                
                let gameKey = selectedGame.key
                let gName = selectedGame.gameName!
                let lB = selectedGame.lowerBound
                let uB = selectedGame.upperBound
                let m = selectedGame.multiplier
                let r = selectedGame.reward
                viewcontroller.gameID = gameKey
                viewcontroller.gName = gName
                viewcontroller.range = lB!+"-"+uB!
                viewcontroller.multiplier = "\(m!)"
                viewcontroller.reward = "\(r!)"
                }
            }
        }
        
    }
    
    
    // MARK - Load Game Data

    func loadGuessingGameData() {
        var newData: [GuessingGame] = [
            GuessingGame(_name: "Game1", _lowerBound: "0", _upperBound: "1000", _multiplier: 0.1, _reward: 10)]
        newData.removeAll()
        players.removeAll()
        
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if let postData = snapshot.value as? [String : AnyObject] {
                print("")
                print("**wassup**")
               // if let gamesList = postData["games"] {
                    
                    //get guessing Games
//                    if let gGamesList = postData["games"] as? [String: AnyObject] {
                        //get individual games, and add them to the arrary
                        print("JERE")
                        for child in postData {
                            let tempKey = child.0
                            if let tempName = child.1["gameName"] as? String {
                                if let tempUBound = child.1["upperRange"] as? String {
                                    if let tempLBound = child.1["lowerRange"] as? String {
                                        if let tempMultiplier = child.1["multiplier"] as? String {
                                            if let tempReward = child.1["reward"] as? String {
                                                self.players.append(GuessingGame(_name: tempName, _lowerBound: tempLBound, _upperBound: tempUBound, _multiplier: Float(tempMultiplier), _reward: Int(tempReward), _key: tempKey))
                                                print()
                                                print("made it here")
                                                print()
                                                
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
                    
                //} else {
                  //  print("error on line 61")
                //}
//            } else {
//                print("__WEVE GOT A BIG FUCKING PROBLEM__")
//            }
             self.tableView.reloadData()
        })
        
        

    }
    

}

