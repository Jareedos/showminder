//
//  UIColor+Pallete.swift
//  showminder
//
//  Created by Jared Sobol on 10/1/16.
//  Copyright © 2016 Appmaker. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var showMinderGray : UIColor {
        return UIColorFromRGB(rgbValue: 0xB8B8B8)
    }
}



func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

extension String {
    func hexValue() -> UInt {
        var r:CUnsignedInt = 0
        Scanner(string: self).scanHexInt32(&r)
        return UInt(r)
    }
}
