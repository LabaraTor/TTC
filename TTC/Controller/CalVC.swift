//
//  CalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 10.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FSCalendar

class CalVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calView: FSCalendar!
    
    var curCal: TTCalendar!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
//        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()
    
    var a:TimeInterval = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = curCal?.name
        tableView.delegate = self
        tableView.dataSource = self
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
        return self.formatter.date(from: curCal.endDate!)!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: curCal.startDate!)!
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return Event.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventTableCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell!
        cell.eventTitle.text = Event.list[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
