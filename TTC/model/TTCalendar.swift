//
//  File.swift
//  TTC
//
//  Created by Торнике Двалашвили on 11.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import Foundation

class TTCalendar: NSObject{
    
    var name: String?
    var startDate: String?
    var endDate: String?
    var close: String?
    
    init(name: String, startDate: String, endDate: String, close: String) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.close = close
    }
    override init(){}
    
}
