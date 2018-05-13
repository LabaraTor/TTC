//
//  Event.swift
//  TTC
//
//  Created by Торнике Двалашвили on 13.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import Foundation

class Event: NSObject{
    
    static var list: Array<Event> = Array()
    
    var title: String?
    var descr: String?
    var startTime: String?
    var endTime: String?
    
    init(title: String, descr: String, startTime: String, endTime: String) {
        self.title = title
        self.descr = descr
        self.startTime = startTime
        self.endTime = endTime
    }
    override init(){}
    
}
