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
        // Toggle the follow setting for this show
        followingRef.setValue(!isFollowing)
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
  
    

}
