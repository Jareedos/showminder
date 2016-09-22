//
//  DataService.swift
//  showminder
//
//  Created by Jared Sobol on 9/8/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Firebase

let URL_BASE = FIRDatabase.database().reference()

class DataService {
    static let ds = DataService()
    
    private var _REF_BASE = URL_BASE
    private var _REF_USERS = URL_BASE.child("users")
    private var _REF_SHOWS = URL_BASE.child("shows")

    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_SHOWS: FIRDatabaseReference {
        return _REF_SHOWS
    }
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    
    func createFirebaseDBUser(uid: String, userEmail: Dictionary<String, String>, cableProvider: Dictionary<String, String>, timeZone: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userEmail)
        REF_USERS.child(uid).updateChildValues(cableProvider)
        REF_USERS.child(uid).updateChildValues(timeZone)
    }

}

