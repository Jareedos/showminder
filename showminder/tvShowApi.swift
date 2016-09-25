//
//  tvShowApi.swift
//  showminder
//
//  Created by Jared Sobol on 9/15/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Alamofire

func callApi(completed: @escaping DownloadComplete) {
    
    Alamofire.request("https://www.parsehub.com/api/v2/projects/\(projectToken)/last_ready_run/data?api_key=\(apiAccessToken)&format=json").responseJSON
        { response in
            
            if let dict = response.result.value as? Dictionary<String, AnyObject> {
                if let name = dict["results"]?["tvShows"] {
                print(name)
                completed()
                }
            }
            
            //        print("result of calling to api is: ", result, " data: ", response.data)
            
    }
    
}

func callUpdateApiIfNeed() {
    let keyForSaveUd = "prevTimeForApiCall"
    let ud = UserDefaults.standard
    let timerDouble = ud.double(forKey: keyForSaveUd)
    let now = CFAbsoluteTimeGetCurrent()
    let timeSinceLastApiCall = now - timerDouble
    if (timeSinceLastApiCall < 60 * 60 * 24) {
        return
    }
    // call api
    callApi(completed: {
       let now1 = CFAbsoluteTimeGetCurrent()
       ud.set(now1, forKey: keyForSaveUd)
    })
}

//func pushNotification
