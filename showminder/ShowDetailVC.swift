//
//  ShowDetailVC.swift
//  showminder
//
//  Created by Jared Sobol on 9/23/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit

class ShowDetailVC: UIViewController {
    var selectedTvShow: TvShow!

    @IBOutlet weak var tvShowImg: UIImageView!
    @IBOutlet weak var showTitleLbl: UILabel!
    @IBOutlet weak var epidsodeTitleLbl: UILabel!
    @IBOutlet weak var seasonNumberLbl: UILabel!
    @IBOutlet weak var episodeNumberLbl: UILabel!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var showDayLbl: UILabel!
    @IBOutlet weak var showDateLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        tvShowImg.image = #imageLiteral(resourceName: "tv_show_image_is_not_available")
        tvShowImg.af_cancelImageRequest()
        if let imageURL = selectedTvShow.imageURL {
            tvShowImg.af_setImage(withURL: imageURL)
        }
        showTitleLbl.text = selectedTvShow.name
        epidsodeTitleLbl.text = selectedTvShow.episodeTitle
        episodeNumberLbl.text = selectedTvShow.episodeNumber
        seasonNumberLbl.text = selectedTvShow.seasonNumber
        channelNameLbl.text = selectedTvShow.channel
        showDayLbl.text = selectedTvShow.dayOfTheWeek
        showDateLbl.text = selectedTvShow.date
        
        print(selectedTvShow.showTime)
        print(selectedTvShow.episodeTitle)
        print(selectedTvShow.episodeNumber)
        print(selectedTvShow.seasonNumber)
        print(selectedTvShow.channel)
        print(selectedTvShow.dayOfTheWeek)
        print(selectedTvShow.date)
        
     
    }

    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
  
    

}
