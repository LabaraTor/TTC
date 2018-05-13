//
//  CalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 10.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FSCalendar

class CalVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate {
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calView: FSCalendar!
    
    var curCal: TTCalendar?
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()
    
    var a:TimeInterval = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = curCal?.name
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func toggleClicked(sender: AnyObject) {
        if self.calendar.scope == .month {
            self.calendar.setScope(.week, animated: true)
        } else {
            self.calendar.setScope(.month, animated: true)
        }
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calView.fs_height = bounds.height
        self.tableView.fs_height += 500
        self.view.layoutIfNeeded()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2018 07 01")!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        let date = NSDate(timeIntervalSinceNow: -90*24*60*60)
        return date as Date
    }
}
