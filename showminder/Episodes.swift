//
//  Episodes.swift
//  showminder
//
//  Created by Jared Sobol on 10/28/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase

class Episode {
    var key = ""
    
    var channel : String
    var episode : String
    var episodeTitle : String
    var name : String
    var seasonNumber : String
    var showId : String
    var timestamp : TimeInterval
    var imageURL: URL?
    
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.key = snapshot.key
        
        self.channel = value["channel"] as? String ?? "Not Available"
        self.episode = value["episodeNumber"] as? String ?? "Not Available"
        self.episodeTitle = value["episodeTitle"] as? String ?? "Not Available"
        self.name = value["name"] as? String ?? "Not Available"
        self.seasonNumber = value["seasonNumber"] as? String ?? "Not Available"
        self.showId = value["showId"] as? String ?? "Not Available"
        self.timestamp = value["timestamp"] as? TimeInterval ?? 0.0
        if let image = value["image"] as? String {
            imageURL = URL(string: image)
        }
        
    }
    
    func getImageURL(completion: @escaping (_ imageURL: URL)->Void) {
        if let imageURL = imageURL {
            completion(imageURL)
        } else {
            DataService.ds.REF_SHOWS.child(showId).child("image").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
                if let string = snapshot.value as? String, let imageURL = URL(string: string) {
                    completion(imageURL)
                }
            }
        }
    }
    func showDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
    func showDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date(timeIntervalSince1970: timestamp))
    }
}
