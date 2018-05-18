//
//  ReqCell.swift
//  TTC
//
//  Created by Торнике Двалашвили on 17.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

class ReqCell: UITableViewCell {

    var ButtonHandler:(()-> Void)!
    
    @IBOutlet weak var title: UILabel!
    
    @IBAction func add(_ sender: Any) {
        self.ButtonHandler()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
