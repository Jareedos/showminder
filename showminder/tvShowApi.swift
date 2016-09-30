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
                
                var imageFileNames = imageFileNames
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
                                        if let dateString = show["date"] as? String, let timeString = show["showTime"] as? String {
                                            let dateComponents = dateString.components(separatedBy: " ")
                                            if dateComponents.count == 2 {
                                                let dateFormatter = DateFormatter()
                                                dateFormatter.dateFormat = "h:mm a EEEE M/d/y"
                                                dateFormatter.timeZone = TimeZone(abbreviation: "EST")
                                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                                let date = dateFormatter.date(from: "\(timeString) \(dateString)")
                                                
                                                showToSave["showingDay"] = dateComponents[0]
                                                showToSave["date"] = dateComponents[1]
                                            }
                                        }
                                        
                                        
                                        showToSave["image"] = nil // removing the image field
                                        
                                        reference.child(showId).updateChildValues(showToSave)
                                        
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
