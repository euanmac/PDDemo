//
//  Extensions.swift
//  PDDemo
//
//  Created by Euan Macfarlane on 07/01/2019.
//  Copyright © 2019 pddemo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hex:Int, alpha:CGFloat = 1.0) {
        self.init(
            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
            alpha: alpha
        )
    }
    
    
    static var palette1: UIColor {
        get {
            return UIColor(hex: 0x2E3944)
        }
    }
    
    
    //Dark green (Storm Cloud)
    static var palette2: UIColor {
        get {
            return UIColor(hex: 0x4E6E5D)
        }
    }
    
    //Red (Rusty Red)
    static var palette3: UIColor {
        get {
            return UIColor(hex: 0xDB324D)
        }
    }
    
    //Grey (Spanish Grey)
    static var palette4: UIColor {
        get {
            return UIColor(hex: 0xA29C9B)
        }
    }
    
    //White
    static var palette5: UIColor {
        get {
            return UIColor(hex: 0xFFFFFF)
        }
    }
    
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.2) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}
