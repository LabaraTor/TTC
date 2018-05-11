//
//  File.swift
//  TTC
//
//  Created by Торнике Двалашвили on 11.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import Foundation

class TTCalendar{
    
    var name = String()
    var startDate = String()
    var endDate = String()
    var close = Bool()
    
    init(name: String, startDate: String, endDate: String, close: Bool) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.close = close
    }
    init(){}
    
}
