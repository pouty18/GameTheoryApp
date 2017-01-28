//
//  GuessingGamesTableViewController.swift
//  GTA2
//
//  Created by Richard Poutier on 1/27/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit

struct GuessingGame {
    var lowerBound: String?
    var upperBound: String?
    var multiplier: Float?
    var reward: Int?
    
    init(_lowerBound: String?, _upperBound: String?, _multiplier: Float?, _reward: Int?) {
        self.lowerBound = _lowerBound
        self.upperBound = _upperBound
        self.multiplier = _multiplier
        self.reward = _reward
    }
}

class GuessingGamesTableViewController: UITableViewController {
    
    let playerData = [
    GuessingGame(_lowerBound: "0", _upperBound: "1000", _multiplier: 0.1, _reward: 10),
    GuessingGame(_lowerBound: "0", _upperBound: "500", _multiplier: 0.4, _reward: 5),
    GuessingGame(_lowerBound: "100", _upperBound: "500", _multiplier: 0.8, _reward: 15),
    GuessingGame(_lowerBound: "0", _upperBound: "5000", _multiplier: 0.75, _reward: 20)]
    
    let players = playerData

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
            cell.textLabel?.text = GuessingGame.name
            cell.detailTextLabel?.text = GuessingGame.game
            return cell
    }
}
