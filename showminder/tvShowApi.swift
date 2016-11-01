//
//  tvShowApi.swift
//  showminder
//
//  Created by Jared Sobol on 9/15/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import Alamofire
import Firebase
import FirebaseStorage


func getImageFileNames(completed: @escaping (_ fileNames: NSDictionary)->Void) {
    FIRDatabase.database().reference().child("fileNames").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
        if let value = snapshot.value as? NSDictionary {
            completed(value)
        }
    }
}

func callApi(completed: @escaping DownloadComplete) {
    getImageFileNames { (imageFileNames: NSDictionary) in
        
        Alamofire.request("https://www.parsehub.com/api/v2/projects/\(projectToken)/last_ready_run/data?api_key=\(apiAccessToken)&format=json").responseJSON
            { response in
                
                let imageFileNames = imageFileNames
                let keys = imageFileNames.allKeys as! [String]
                
                let reference = DataService.ds.REF_SHOWS
                
                if let dict = response.result.value as? Dictionary<String, AnyObject> {
                    if let days = dict["results"] as? [[String: Any]] {
                        for day in days {
                            if let shows = day["tvShows"] as? [[String: Any]] {
                                for show in shows {
                                    
                                    if let name = show["name"] as? String, let channel = show["channel"] as? String {
                                        
                                        // Skip non-US channels
                                        if (channel.contains("(")) {
                                            continue
                                        }
                                        
                                        
                                        var showId = name + channel
                                        showId = showId.replacingOccurrences(of: " ", with: "") //#' '$' '[' or ']
                                        showId = showId.replacingOccurrences(of: "#", with: "")
                                        showId = showId.replacingOccurrences(of: ".", with: "")
                                        showId = showId.replacingOccurrences(of: "$", with: "")
                                        showId = showId.replacingOccurrences(of: "[", with: "")
                                        showId = showId.replacingOccurrences(of: "]", with: "")
                                        
                                        var showToSave = show
                                        
                                        // Episode Title, Season number and Episode number
                                        if let episode = show["SeasonNumber"] as? String {
                                            
                                            // Parse the episode and season number
                                            let components = (episode as NSString).components(separatedBy: ", ")
                                            if components.count == 2 {
                                                showToSave["seasonNumber"] = components[0]
                                            }
                                        }
                                        
                                        // Remove the episodes from the show dictionary to save
                                        showToSave["episodeNumber"] = nil
                                        // Remove the date and showTime
                                        showToSave["date"] = nil
                                        showToSave["showTime"] = nil
                                        
                                        // Save the Show
                                        reference.child(showId).updateChildValues(showToSave)
                                        
                                        
                                        
                                        if let episodes = show["episodeNumber"] as? [[String: Any]], let showTime = show["showTime"] as? String {
                                            
                                            var hasAlreadyPickedTheNextEpisode = false
                                            var i = 0
                                            
                                            for episode in episodes {
                                                if let dateString = episode["episodeDate"] as? String {
                                                    // Get the timestamp
                                                    let dateFormatter = DateFormatter()
                                                    dateFormatter.dateFormat = "dd/MM/yyyyh:mm a"
                                                    let string = dateString + showTime
                                                    
                                                    if let date = dateFormatter.date(from: string) {
                                                        
                                                        let timestamp = date.timeIntervalSince1970
                                                        
                                                        var episodeToSave = episode
                                                        episodeToSave["timestamp"] = timestamp
                                                        episodeToSave["name"] = name
                                                        episodeToSave["episode"] = episode["name"]
                                                        episodeToSave["channel"] = channel
                                                        episodeToSave["showId"] = showId
                                                        episodeToSave["seasonNumber"] = showToSave["seasonNumber"]
                                                        episodeToSave["episodeDate"] = nil
                                                        
                                                        
                                                        let episodeKey = String(format: "%.0f", timestamp)
                                                        let dateKey = dateString.replacingOccurrences(of: "/", with: "-")
                                                        // Put the episode into episodesByDate
                                                        DataService.ds.REF_EPISODES_BY_DATE.child(dateKey).child(episodeKey).setValue(episodeToSave)
                                                        
                                                        // Put the episode into episodesByShow
                                                        DataService.ds.REF_EPISODES_BY_SHOW.child(showId).child(episodeKey).setValue(episodeToSave)
                                                        
                                                        // Put the episode into nextEpisodes
                                                        
                                                        let theShowWasntAiredYet = Date().timeIntervalSince(date) < 0
                                                        let thisIsTheLastShowOfTheSeason = i + 1 == episodes.count
                                                        let thisIsTheNextShow = (theShowWasntAiredYet || thisIsTheLastShowOfTheSeason) && hasAlreadyPickedTheNextEpisode == false
                                                        if thisIsTheNextShow {
                                                            hasAlreadyPickedTheNextEpisode = true
                                                            DataService.ds.REF_EPISODES_NEXT.child(showId).setValue(episodeToSave)
                                                        }
                                                    }
                                                    i += 1
                                                }
                                            }// End of the for loop
                                            
                                            
                                        }
                                    
                                        
                                        /*
                                        for fileNameKey in keys {
                                            if let fileName = imageFileNames[fileNameKey] as? String {
                                                
                                                let name = (fileName.replacingOccurrences(of: "_", with: "") as NSString)
                                                
                                                let limit : Int = min(name.length, showId.characters.count, 5)
                                                let showMatchingString1 = name.substring(to: limit).lowercased()

                                                let showMatchingString2 = (showId as NSString).substring(to: limit).lowercased()
                                                if showMatchingString1 == showMatchingString2 {
                                                    // Match found!!
                                                    // Assign URL
                                                    FIRStorage.storage().reference().child(fileName).downloadURL(completion: { (url: URL?, error: Error?) in
                                                        if let firebaseURL = url {
                                                            FIRDatabase.database().reference().child("shows").child(showId).child("image").setValue(firebaseURL.absoluteString)
                                                        }
                                                    })
                                                    
                                                    // Remove from imageFileNames
                                                    imageFileNames.setValue(nil, forKey: fileNameKey)
                                                    // Remove from firebase
                                                    FIRDatabase.database().reference().child("fileNames").child(fileNameKey).removeValue()
                                                    break
                                                }
                                            }
                                        }
 */
                                        
                                        // Download the image and save the proper url
//                                        if let url = show["image"] as? String {
                                            //                                        downloadImage(fromLink: url, showId: showId, completed: { (firebaseURL: URL) in
                                            //                                            reference.child(showId).child("image").setValue(firebaseURL.absoluteString)
                                            //                                        })
//                                        }
                                    }
                                    
                                    
                                    print(show["name"])
                                }
                            }
                        }
                        completed()
                    }
                }
                
                //        print("result of calling to api is: ", result, " data: ", response.data)
                
        }
    }
    
}

func callUpdateApiIfNeed() {
    checkForUpdateTimestamp { (shouldUpdate: Bool) in
        if shouldUpdate {
            callApi(completed: {
                FIRDatabase.database().reference().child("lastUpdated").setValue(NSDate().timeIntervalSince1970)
            })
        }
    }
}


func checkForUpdateTimestamp(completion: @escaping (_ shouldUpdate: Bool)->Void) {
    FIRDatabase.database().reference().child("lastUpdated").observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
        if let timestampValue = snapshot.value as? Double {
            let date = Date(timeIntervalSince1970: timestampValue)
//            print(date)
            let expirationDate = Date(timeIntervalSinceNow: -24*60*60)
//            print(expirationDate)
            let shouldUpdate = expirationDate.compare(date) == .orderedDescending
            completion(shouldUpdate)
        }
    }
}


func downloadImage(fromLink  url: String, showId: String, completed: @escaping (_ firebaseURL: URL)->Void) {
    
    Alamofire.request(url).responseData
        { response in
            if let data = response.data {
                STORAGE_BASE.child("show-images").child(showId).put(data, metadata: nil, completion: { (metadata: FIRStorageMetadata?, error: Error?) in
                    if let url = metadata?.downloadURL() {
                        completed(url)
                    }
                })
            }
            
        
    }
}

//func pushNotification
