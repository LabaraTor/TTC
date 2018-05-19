//
//  CalTableCellView.swift
//  TTC
//
//  Created by Торнике Двалашвили on 19.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class CalTableCellView: UIView {

    override func awakeFromNib() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.height / 6.0
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 6)
        self.layer.shadowRadius = 4
    }

}
