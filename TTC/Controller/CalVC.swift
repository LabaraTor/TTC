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
    
    var list: Array<Event> = Array()
    
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
        list = []
        Database.database().reference().child("events").child((Auth.auth().currentUser?.uid)!).child(CalVC.curCal.name!).child(self.formatter1.string(from: CalVC.selectedDate)).observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(dictionary)
                let event = Event()
//                event.setValuesForKeys(dictionary)
                event.title = dictionary["title"] as? String
                event.startTime = dictionary["startTime"] as? String
                event.endTime = dictionary["endTime"] as? String
                event.descr = dictionary["descr"] as? String
                if dictionary["with"] as? String != nil{
                    event.with = dictionary["with"] as? String
                }
                self.list.append(event)
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
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventTableCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell!
        let user = list[indexPath.row]
        cell.eventTitle.text = user.title
        cell.startTime.text = user.startTime
        cell.endTime.text = user.endTime

        if user.with != nil{
            Database.database().reference().child("users").child(user.with!).observeSingleEvent(of: .value, with: { (snapshot) in
                let userDict = snapshot.value as! [String: Any]
                
                let with = userDict["Nickname"] as! String
                cell.with.text = "With \(with)"
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            Database.database().reference().child("events").child((Auth.auth().currentUser?.uid)!).child(CalVC.curCal.name!).child(self.formatter1.string(from: CalVC.selectedDate)).child(list[indexPath.row].title!).setValue(nil)
            list.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
