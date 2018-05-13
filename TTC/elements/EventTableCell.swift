//
//  EventTableCell.swift
//  TTC
//
//  Created by Торнике Двалашвили on 13.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class EventTableCell: UITableViewCell {
    
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
