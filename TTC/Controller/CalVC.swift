//
//  CalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 10.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase
import FirebaseDatabase

class CalVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var calView: FSCalendar!
    
    static var curCal: TTCalendar!
    static var selectedDate: Date!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    fileprivate let formatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = CalVC.curCal?.name
        tableView.delegate = self
        tableView.dataSource = self
        CalVC.selectedDate = calendar.today
        fetchEvents()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchEvents(){
        Event.list = []
        Database.database().reference().child("events").child((Auth.auth().currentUser?.uid)!).child(CalVC.curCal.name!).child(self.formatter1.string(from: CalVC.selectedDate)).observeSingleEvent(of: .childAdded) { (snapshot) in
            print(snapshot)
            //сделать словарь в класс
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(dictionary)
                let event = Event()
//                event.setValuesForKeys(dictionary)
                event.title = dictionary["title"] as? String
                event.startTime = dictionary["startTime"] as? String
                event.endTime = dictionary["endTime"] as? String
                event.descr = dictionary["descr"] as? String
                Event.list.append(event)
            }
            self.tableView.reloadData()
        }
        self.tableView.reloadData()
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        CalVC.selectedDate = date
        fetchEvents()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: CalVC.curCal.endDate!)!
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: CalVC.curCal.startDate!)!
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return Event.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventTableCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell!
        cell.eventTitle.text = Event.list[indexPath.row].title
        cell.startTime.text = Event.list[indexPath.row].startTime
        cell.endTime.text = Event.list[indexPath.row].endTime
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            Database.database().reference().child("events").child((Auth.auth().currentUser?.uid)!).child(CalVC.curCal.name!).child(self.formatter1.string(from: CalVC.selectedDate)).child(Event.list[indexPath.row].title!).setValue(nil)
            Event.list.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
