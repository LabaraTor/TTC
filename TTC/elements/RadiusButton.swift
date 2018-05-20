//
//  RadiusButton.swift
//  TTC
//
//  Created by Торнике Двалашвили on 19.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class RadiusButton: UIButton {

    override func awakeFromNib() {
        self.layoutIfNeeded()
        layer.cornerRadius = self.frame.height / 2.0
        layer.masksToBounds = false
        layer.shadowColor = UIColor.red.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 3
    }

}
