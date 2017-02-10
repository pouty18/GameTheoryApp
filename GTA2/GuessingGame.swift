//
//  GuessingGame.swift
//  GTA2
//
//  Created by Richard Poutier on 1/27/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import Foundation
import Firebase

struct GuessingGame {
    var key: String
    
    var gameName: String?
    
    var lowerBound: String?
    
    var upperBound: String?
    
    var multiplier: Float?
    
    var reward: Int?

    var ref: FIRDatabaseReference?
    
    init(_name: String?, _lowerBound: String?, _upperBound: String?, _multiplier: Float?, _reward: Int?, _key: String = "") {
        self.key = _key
        self.gameName = _name
        self.lowerBound = _lowerBound
        self.upperBound = _upperBound
        self.multiplier = _multiplier
        self.reward = _reward
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        gameName = snapshotValue["gameName"] as? String
        lowerBound = snapshotValue["lowerB?und"] as? String
        upperBound = snapshotValue["upperBound"] as? String
        multiplier = snapshotValue["multiplier"] as? Float
        reward = snapshotValue["reward"] as? Int
        ref = snapshot.ref
    }
    
    
    
    func toAnyObject() -> Any {
        return [
            "name": gameName,
            "range": getRange(),
            "multiplier": String(describing: multiplier),
            "reward": String(describing: reward)
        ]
    }
    
    func getRange() -> String {
        return lowerBound!+"-"+upperBound!
    }
}
