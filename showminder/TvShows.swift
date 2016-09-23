//
//  TvShows.swift
//  showminder
//
//  Created by Jared Sobol on 9/22/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Alamofire

class TvShow {
    
    private var _name: String!
    private var _episodeNumber: Int!
    private var _seasonNumber: Int!
    private var _episodeTitle: String!
    private var _showTime: String!
    private var _channel: String!
    private var _dayOfTheWeek: String!
    private var _date: String!
    
    
    var name: String {
        return _name
    }
    
    var episodeNumber: Int {
        return _episodeNumber
    }
    
    var seasonNumber: Int {
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
    
    init(name: String, episodeNumber: Int, seasonNumber: Int, episodeTitle: String, showtime: String, channel: String, dayOfTheWeek: String, date: String) {
        self._name = name
        self._episodeNumber = episodeNumber
        self._seasonNumber = seasonNumber
        self._episodeTitle = episodeTitle
        self._showTime = showTime
        self._channel = channel
        self._dayOfTheWeek = dayOfTheWeek
        self._date = date
        
    }
    
    func createShows(completed: @escaping DownloadComplete) {
        
        Alamofire.request("https://www.parsehub.com/api/v2/projects/\(projectToken)/last_ready_run/data?api_key=\(apiAccessToken)&format=json").responseJSON
            { response in
                
                if let result = response.result.value {
                    //let JSON = result as! NSDictionary
                    //print(JSON)
                    completed()
                }
                
                //        print("result of calling to api is: ", result, " data: ", response.data)
                
        }
        
    }
}
