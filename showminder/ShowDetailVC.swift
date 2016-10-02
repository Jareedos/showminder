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
    @IBOutlet weak var episodeNumberLbl: UILabel!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var showDayLbl: UILabel!
    @IBOutlet weak var showDateLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

     
        tvShowImg.image = selectedTvShow.imageURL
    }

  
    

}
