//
//  ShowCell.swift
//  showminder
//
//  Created by Jared Sobol on 9/22/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit

class ShowCell: UICollectionViewCell {
    
    @IBOutlet weak var showImg: UIImageView!
    @IBOutlet weak var shownameLbl: UILabel!
    
    var show: TvShow!
    
    func configureCell(show: TvShow) {
        self.show = show
        
        shownameLbl.text = self.show.name.capitalized
//        showImg.image = UIImage(named: )
    }
    
}
