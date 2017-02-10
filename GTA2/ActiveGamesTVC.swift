//
//  ActiveGamesTVC.swift
//  GTA2
//
//  Created by Richard Poutier on 2/6/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit

import Firebase

class ActiveGamesTVC: UITableViewController {

    var subRef = FIRDatabase.database().reference(withPath: "submissions")
    var gamesRef = FIRDatabase.database().reference(withPath: "games")
    var rootRef = FIRDatabase.database().reference()

    var multiplier: Float = 0.0
    
    var guesses:[Float] = []
    
    var games:[GuessingGame] = playerData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        loadGuessingGameData()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath)

        let game = games[indexPath.row] as GuessingGame
        
        cell.textLabel?.text = game.gameName
        cell.detailTextLabel?.text = "Select to Analyze"
        // Configure the cell...

        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // *** Here we want to add in to the database that our current user selected to play this game
        // add to table 'Active Games' - List of all players and the games they are playing
//        presentAlertView("Analysis Started", _message: "Analysis started for: \"\(games[indexPath.row].gameName!)\"")
        analyzeGameData(index: indexPath.row)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - IBACTIONS
    
    @IBAction func doneWithTable(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Data retrival
    func loadGuessingGameData() {
        var newData: [GuessingGame] = [
            GuessingGame(_name: "Game1", _lowerBound: "0", _upperBound: "1000", _multiplier: 0.1, _reward: 10)]
        newData.removeAll()
        games.removeAll()
        
        gamesRef.observeSingleEvent(of: .value, with: { snapshot in
            if let postData = snapshot.value as? [String : AnyObject] {
                print("")
                print("**wassup**")
                // if let gamesList = postData["games"] {
                
                //get guessing Games
                if let gGamesList = postData["guessingGames"] as? [String: AnyObject] {
                    //get individual games, and add them to the arrary
                    
                    for child in gGamesList {
                        let tempKey = child.0
                        if let tempName = child.1["gameName"] as? String {
                            if let tempUBound = child.1["upperRange"] as? String {
                                if let tempLBound = child.1["lowerRange"] as? String {
                                    if let tempMultiplier = child.1["multiplier"] as? String {
                                        if let tempReward = child.1["reward"] as? String {
                                            self.games.append(GuessingGame(_name: tempName, _lowerBound: tempLBound, _upperBound: tempUBound, _multiplier: Float(tempMultiplier), _reward: Int(tempReward), _key: tempKey))
                                            
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
            } else {
                print("__WEVE GOT A BIG FUCKING PROBLEM__")
            }
            self.tableView.reloadData()
        })
    }
    
    func presentAlertView(_ _title: String, _message: String) {
        
        let alert = UIAlertController(title: _title, message: _message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Game Analysis
    func analyzeGameData(index: Int) {
        print("Analysis Started")
        
        subRef.observeSingleEvent(of: .value, with: { snapshot in
            
            if let postData = snapshot.value as? [String: AnyObject] {
                
                for currentUser in postData {
                    
                    if let gameData = currentUser.value as? [String : AnyObject] {
//                        print("game Data = \(gameData)")
                        
                        for currentGame in gameData {
                            
                            if currentGame.key == self.games[index].key {
                                print("Round data for selected row: \(currentGame.value)")
                                if let rounds = currentGame.value as? [String : AnyObject] {
                                    for round in rounds {
                                        if round.key == "round-0" {
                                            if let guess = round.value as? [String : AnyObject] {
                                                if let result = guess["guess"] as? String {
                                                    self.guesses.append(Float(result)!)
                                                    print("success")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            print("Compuation = \(self.getCompuation(withMultiplier: self.games[index].multiplier!))")
            //update Database results value
            
            self.presentAlertView("Computation Finished", _message: "Value = \(self.getCompuation(withMultiplier: self.games[index].multiplier!))")
            
            //let's a user try and update values twice, to accept more input
            self.guesses.removeAll()
        })
    }

    func getCompuation(withMultiplier: Float) -> Float {
        var total:Float = 0
        for item in guesses {
            print("current item = \(item)")
            print("running total = \(total)")
            
            total += item
        }
        total = total/Float(guesses.count)
        total = total*withMultiplier
        return total
    }



}
