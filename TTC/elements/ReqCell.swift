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
    var CancelButtonHandler:(()-> Void)!
    
    @IBOutlet weak var ProfileImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var starttime: UILabel!
    @IBOutlet weak var endtime: UILabel!
    @IBOutlet weak var descr: UILabel!
    
    @IBAction func add(_ sender: Any) {
        self.ButtonHandler()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.CancelButtonHandler()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
