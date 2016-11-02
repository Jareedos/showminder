//
//  MaterialImage.swift
//  showminder
//
//  Created by Jared Sobol on 10/3/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit

class MaterialImage: UIImageView {

    override func awakeFromNib() {
        layoutIfNeeded()
        layer.cornerRadius = 5.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
        clipsToBounds = true
    }

}
