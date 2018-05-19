//
//  RadiusTF.swift
//  TTC
//
//  Created by Торнике Двалашвили on 19.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class RadiusTF: UIView {
    
    override func awakeFromNib() {
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2.0
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 4
    }

}
