//
//  CallTableCell.swift
//  TTC
//
//  Created by Торнике Двалашвили on 11.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class CallTableCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var descr: UILabel!
    @IBOutlet weak var locked: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
