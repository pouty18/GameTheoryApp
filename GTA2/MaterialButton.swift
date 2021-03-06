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
        layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.5).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        
    }
    
}
