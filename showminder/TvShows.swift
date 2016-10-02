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
    
    private var _name: String!
    private var _episodeNumber: String!
    private var _seasonNumber: String!
    private var _episodeTitle: String!
    private var _showTime: String!
    private var _channel: String!
    private var _dayOfTheWeek: String!
    private var _date: String!
    
    
    var name: String {
        return _name
    }
    
    var episodeNumber: String {
        return _episodeNumber
    }
    
    var seasonNumber: String {
        return _seasonNumber
    }
    
    var episodeTitle: String {
        return _episodeTitle
    }
    
    var showTime: String {
        return _showTime
    }
    
    var channel: String {
        return _channel
    }
    
    var dayOfTheWeek: String {
        return _dayOfTheWeek
    }
    
    var date: String {
        return _date
    }
    
    var imageURL: URL?
    
    init(name: String, episodeNumber: String, seasonNumber: String, episodeTitle: String, showtime: String, channel: String, dayOfTheWeek: String, date: String) {
        self._name = name
        self._episodeNumber = episodeNumber
        self._seasonNumber = seasonNumber
        self._episodeTitle = episodeTitle
        self._showTime = showTime
        self._channel = channel
        self._dayOfTheWeek = dayOfTheWeek
        self._date = date
        
    }
    
    init(snapshot: FIRDataSnapshot) {
        let value = snapshot.value as! NSDictionary
        self._name = value["name"] as? String ?? ""
        self._episodeNumber = value["episodeNumber"] as? String ?? ""
        self._seasonNumber = value["seasonNumber"] as? String ?? ""
        self._episodeTitle = value["episodeTitle"] as? String ?? ""
        self._showTime = value["showTime"] as? String ?? ""
        self._channel = value["channel"] as? String ?? ""
        self._dayOfTheWeek = value["dayOfTheWeek"] as? String ?? ""
        self._date = value["date"] as? String ?? ""
        if let image = value["image"] as? String {
            imageURL = URL(string: image)
        }
    }
    
    func createShows(completed: @escaping DownloadComplete) {
        
        Alamofire.request("https://www.parsehub.com/api/v2/projects/\(projectToken)/last_ready_run/data?api_key=\(apiAccessToken)&format=json").responseJSON
            { response in
                
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    print(JSON)
                    
                    completed()
                  
                }
                
                //        print("result of calling to api is: ", result, " data: ", response.data)
                
        }
        
    }
    

}
