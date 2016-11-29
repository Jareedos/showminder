//
//  ShowDetailVC.swift
//  showminder
//
//  Created by Jared Sobol on 9/23/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import UserNotifications


class ShowDetailVC: UIViewController {
    var episode: Episode!

    @IBOutlet weak var tvShowImg: UIImageView!
    @IBOutlet weak var showTitleLbl: UILabel!
    @IBOutlet weak var epidsodeTitleLbl: UILabel!
    @IBOutlet weak var seasonNumberLbl: UILabel!
    @IBOutlet weak var episodeNumberLbl: UILabel!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var showDayLbl: UILabel!
    @IBOutlet weak var showDateLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var showTime: UILabel!
    
    var isFollowing = false
    var followingRef : FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tvShowImg.image = #imageLiteral(resourceName: "tv_show_image_is_not_available")
        tvShowImg.af_cancelImageRequest()
        
        episode.getImageURL(completion: { (url: URL) in
            self.tvShowImg.af_setImage(withURL: url)
        })
        tvShowImg.layer.cornerRadius = 5.0
        tvShowImg.layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
        tvShowImg.layer.borderWidth = 1.0
    
        
        showTitleLbl.text = episode.name
        epidsodeTitleLbl.text = episode.episodeTitle
        episodeNumberLbl.text = episode.episode
        seasonNumberLbl.text = episode.seasonNumber
        channelNameLbl.text = episode.channel
        
        showDayLbl.text = episode.showDay()
        showDateLbl.text = episode.showDate()
        showTime.text = episode.showTime()
        
        // St the following ref
        followingRef = DataService.ds.REF_SHOWS_BY_FOLLOWER.child(DataService.ds.currentUserId()).child(self.episode.showId)
        
        // Observe the follow status of the show
        followingRef.observe(.value, with: { snapshot in
            if let isFollowing = snapshot.value as? Bool {
                self.isFollowing = isFollowing
                self.followBtn.setTitle(isFollowing ? "UnFollow" : "Follow", for: .normal)
            }
        })
    }
    
    @IBAction func onFollowBtnPressed(_ sender: AnyObject) {
        
        if (isFollowing == false) {
            
            let alert = UIAlertController(title: "Following \(episode.name)", message: "You are now following \(episode.name), You will now be sent a noitification everytime a new episode or season for \(episode.name) will be airing. \n Please select your which notifications you wish to recieve below", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default , handler: { action in
                self.askTheUserToScheduleNotifications()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            removeNotifications()
        }
        // Toggle the follow setting for this show
        followingRef.setValue(!isFollowing)
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func askTheUserToScheduleNotifications() {
        
        let alert = UIAlertController(title: "Schedule a notification", message: "When would you like to get a notification?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "Same day", style: .default , handler: { (action) in
            self.scheduleAllNotifications(deltaTime: 0.0)
        }))
        alert.addAction( UIAlertAction(title: "A day before", style: .default , handler: { (action) in
            self.scheduleAllNotifications(deltaTime: -24 * 60 * 60)
        }))
        alert.addAction( UIAlertAction(title: "Both", style: .default , handler: { (action) in
            self.scheduleAllNotifications(deltaTime: 0.0)
            self.scheduleAllNotifications(deltaTime: -24 * 60 * 60)
        }))
        alert.addAction( UIAlertAction(title: "Cancel", style: .cancel , handler: { (action) in
            self.followingRef.setValue(!self.isFollowing)
        }))
        present(alert, animated: true, completion: nil)
    }

    func scheduleAllNotifications(deltaTime: TimeInterval) {
        DataService.ds.REF_EPISODES_BY_SHOW.child(episode.showId).observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                if let snap = child as? FIRDataSnapshot {
                    let episode = Episode(snapshot: snap)
                    self.scheduleNotification(episode: episode, deltaTime: deltaTime)
                }
            }
            
        })
    }
    
    func scheduleNotification(episode: Episode, deltaTime: TimeInterval) {
        // Episode airing time + the notification schedule offset
        let inputDate = Date(timeIntervalSince1970: episode.timestamp).addingTimeInterval(deltaTime)
        
        // Get all date components except for the hour and minute
        var components = Calendar.current.dateComponents([.year, .day, .month, .timeZone], from: inputDate)
        // Set the hour to 10
        components.hour = 10
        
        let date = Calendar.current.date(from: components)
        
        let notification = UILocalNotification()
        notification.fireDate = date
        notification.alertTitle = "ShowMinder Showing Alert"
        notification.alertBody = " A new episode of \(episode.name) is on today at \(episode.showDate()). \n Showminder \n All showing times are set for EST & DirectTV, The time maybe be differnt depending on your Provider & timezone"
        notification.userInfo = [
            "showId" : episode.showId
        ]
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func removeNotifications() {
        guard let notifications = UIApplication.shared.scheduledLocalNotifications else {
            return
        }
        // Loop through the scheduled notifications
        for notification in notifications {
            // Find the ones of the current episode's show
            if let userInfo = notification.userInfo, let showId = userInfo["showId"] as? String, showId == episode.showId {
                // Cancel it
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }
    
    func showAlert(_ title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default , handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }

  

}
