//
//  CalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 09.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalVC: UIViewController {
    let formatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CalVC: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {

    }
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalCustomCell", for: indexPath) as! CalCustomCell
        cell.dataLabel.text = cellState.text
        return cell
    }
    
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startTime = formatter.date(from: "2018 01 01")!
        let endTime = formatter.date(from: "2019 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startTime, endDate: endTime)
        return parameters
    }
    
    
}
