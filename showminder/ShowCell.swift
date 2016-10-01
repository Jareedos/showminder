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
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
    }
    
    func configureCell(show: TvShow) {
        self.show = show
        
        shownameLbl.text = self.show.name.capitalized
//        showImg.image = #imageLiteral(resourceName: "tv_show_image_is_not_available")
//        showImg.af_cancelImageRequest()
//        if let imageURL = show.imageURL {
//            showImg.af_setImage(withURL: imageURL)
//        }
    }


    
}
