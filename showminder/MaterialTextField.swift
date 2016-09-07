//
//  MaterialTextField.swift
//  showminder
//
//  Created by Jared Sobol on 9/6/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).CGColor
        layer.borderWidth = 1.0
    }
    
    


}
