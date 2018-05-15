//
//  User.swift
//  TTC
//
//  Created by Торнике Двалашвили on 14.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import Foundation

class User: NSObject{
    
    var nickName: String
    var profileImg: String
    
    init(nickName:String, profileImg:String) {
        self.nickName = nickName
        self.profileImg = profileImg
    }
}
