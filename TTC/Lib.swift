//
//  Lib.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth


class Lib {
    
    static var calList: Array<TTCalendar> = Array()
    
    public static func addCal(newCal: TTCalendar){
        calList.append(newCal)
    }
    
    public static func showError(error: Error) -> UIAlertController
    {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(action)
        return alert
    }
    
}
