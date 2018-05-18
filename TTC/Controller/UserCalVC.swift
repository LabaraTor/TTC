//
//  UserCalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 19.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase
import FSCalendar

class UserCalVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var list: Array<Event> = Array()
    static var curCal: TTCalendar!
    static var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserCalVC.selectedDate = calendar.today
        tableView.delegate = self
        tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        fetchEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        UserCalVC.selectedDate = date
        fetchEvents()
    }
    
    func fetchEvents(){
        list = []
        Database.database().reference().child("events").child((UserVC.user.uid)!).child(UserCalVC.curCal.name!).child(self.formatter1.string(from: UserCalVC.selectedDate)).observe(.childAdded) { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(dictionary)
                let event = Event()
                event.title = dictionary["title"] as? String
                event.startTime = dictionary["startTime"] as? String
                event.endTime = dictionary["endTime"] as? String
                event.descr = dictionary["descr"] as? String
                if dictionary["with"] as? String != nil{
                    event.with = dictionary["with"] as? String
                }
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
                self.list.append(event)
            }
        }
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        print(UserCalVC.curCal.endDate!)
        return self.formatter.date(from: UserCalVC.curCal.endDate!)!
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: UserCalVC.curCal.startDate!)!
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
//        let user = list[indexPath.row]
//        cell.eventTitle.text = user.title
//        cell.startTime.text = user.startTime
//        cell.endTime.text = user.endTime
//
//        if user.with != nil{
//            Database.database().reference().child("users").child(user.with!).observeSingleEvent(of: .value, with: { (snapshot) in
//                let userDict = snapshot.value as! [String: Any]
//
//                let with = userDict["Nickname"] as! String
//                cell.with.text = "With \(with)"
//            })
//        }
        cell.textLabel?.text = list[indexPath.row].title
        return cell
    }

}
