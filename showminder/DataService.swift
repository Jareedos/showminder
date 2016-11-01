//
//  DataService.swift
//  showminder
//
//  Created by Jared Sobol on 9/8/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage


let URL_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
    static let ds = DataService()
    
    let REF_BASE = URL_BASE
    let REF_USERS = URL_BASE.child("users")
    let REF_SHOWS = URL_BASE.child("shows")
    let REF_SHOWS_BY_FOLLOWER = URL_BASE.child("showsByFollower")
    let REF_EPISODES_BY_DATE = URL_BASE.child("episodesByDate")
    let REF_EPISODES_BY_SHOW = URL_BASE.child("episodesByShow")
    let REF_EPISODES_NEXT = URL_BASE.child("episodesNext")
    let REF_SHOW_IMAGES = STORAGE_BASE.child("show-images")
    
    var mainRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    
    
    func createFirebaseDBUser(uid: String, userEmail: Dictionary<String, String>, cableProvider: Dictionary<String, String>, timeZone: Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userEmail)
        REF_USERS.child(uid).updateChildValues(cableProvider)
        REF_USERS.child(uid).updateChildValues(timeZone)
    }
    
    func createFirebaseShows(){
        
    }
    

}

