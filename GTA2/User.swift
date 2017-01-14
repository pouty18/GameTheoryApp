//
//  User.swift
//  GTA2
//
//  Created by Richard Poutier on 1/7/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import UIKit

class User {
    private var _name: String
    private var _email: String
    private var _registrationType: String
    private var _loggedIn: Bool

    var name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }

    var email: String {
        get {
            return _email
        }
        set {
            _email = newValue
        }
    }
    
    var registrationType: String {
        get {
            return _registrationType
        }
        set {
            _registrationType = newValue
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return _loggedIn
        }
        set {
            _loggedIn = newValue
        }
    }
    
    init(name: String, email: String, regtype: String) {
        _name = name
        _email = email
        _registrationType = regtype
        _loggedIn = false
    }
    
    init() {
          _name = "Name not set"
          _email = "Email not set"
          _registrationType = "Registration Type not set"
         _loggedIn = false
    }
    
    func printDetails() {
        print("Name: \(_name)")
        print("Email: \(_email)")
        print("RegistrationType: \(_registrationType)")
        print("Is Logged In: \(_loggedIn)")
    }

}
