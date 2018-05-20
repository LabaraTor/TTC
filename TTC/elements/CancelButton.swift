//
//  CancelButton.swift
//  TTC
//
//  Created by Торнике Двалашвили on 20.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class CancelButton: UIButton {
    override func awakeFromNib() {
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.frame.size.height / 2
    }
}
