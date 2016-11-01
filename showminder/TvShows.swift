//
//  TvShows.swift
//  showminder
//
//  Created by Jared Sobol on 9/22/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Alamofire
import FirebaseDatabase

class TvShow {
    var key = ""
    
    let name: String
    let seasonNumber: String
    let showTime: String
    let channel: String
    let dayOfTheWeek: String
    let episodeNumber: String
    let episodeTitle: String
    let episodeDate: String
    var imageURL: URL?
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self.key = snapshot.key
        self.name = value["name"] as? String ?? "Not Available"
        self.seasonNumber = value["seasonNumber"] as? String ?? "Not Available"
        self.showTime = value["showTime"] as? String ?? "Not Available"
        self.channel = value["channel"] as? String ?? "Not Available"
        self.dayOfTheWeek = value["showingDay"] as? String ?? "Not Available"
        if let image = value["image"] as? String {
            imageURL = URL(string: image)
        }
        
        
        self.episodeNumber = value["episodeNumber"] as? String ?? ""
        self.episodeTitle = value["episodeTitle"] as? String ?? ""
        self.episodeDate = value["episodeDate"] as? String ?? ""
    }
    
    func createShows(completed: @escaping DownloadComplete) {
        
        Alamofire.request("https://www.parsehub.com/api/v2/projects/\(projectToken)/last_ready_run/data?api_key=\(apiAccessToken)&format=json").responseJSON
            { response in
                
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print(JSON)
                    
                    completed()
                  
                }
             
                
        }
        
    }
    

}
