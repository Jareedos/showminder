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
    @IBOutlet weak var tvShowNameLbl: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        tvShowNameLbl.text = selectedTvShow.name
    }

  
    

}
