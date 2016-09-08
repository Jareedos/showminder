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
    private var _REF_POSTS = URL_BASE.child()
    private var _REF_USERS = URL_BASE.child()
    
    var REF_BASE: FIRDatabaseRefernce {
        return _REF_BASE
    }
}
