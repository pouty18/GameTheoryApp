//
//  Game.swift
//  GTA2
//
//  Created by Richard Poutier on 1/31/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import Foundation
import Firebase

class Game {
    var key: String
    
    var gameName: String?
    
    var ref: FIRDatabaseReference?
    
    init(_key: String, _name: String?, _ref: String? = "") {
        self.key = _key
        self.gameName = _name
        self.ref = nil
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        gameName = snapshotValue["gameName"] as? String
        ref = snapshot.ref
    }
    
}