//
//  TvShows.swift
//  showminder
//
//  Created by Jared Sobol on 9/22/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation

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
    
    var showTitle: String {
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
}
