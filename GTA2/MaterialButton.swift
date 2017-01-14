//
//  MaterialButton.swift
//  GTA2
//
//  Created by Richard Poutier on 1/8/17.
//  Copyright © 2017 Richard Poutier. All rights reserved.
//

import Foundation
import UIKit

class MaterialButton: UIButton {
    
    
    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).CGColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSizeMake(0.0, 2.0)
        
    }
    
}
