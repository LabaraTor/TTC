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
    var curCal: TTCalendar!
    var user = User()
    var selectedDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedDate = calendar.today
        tableView.delegate = self
        tableView.dataSource = self
        calendar.delegate = self
        calendar.dataSource = self
        self.navigationItem.title = curCal?.name
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
    
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        fetchEvents()
    }
    
    @IBAction func Add(_ sender: Any) {
        if  selectedDate == calendar.today{
            let sdate = self.formatter2.date(from: curCal.startDate!)
            print(curCal.startDate!)
            let edate = self.formatter2.date(from: curCal.endDate!)
            let sDateStr = self.formatter1.string(from: sdate!)
            let eDateStr = self.formatter1.string(from: edate!)
            if (compare1(date: eDateStr) && !compare2(date: sDateStr)){
                performSegue(withIdentifier: "addUserEvent", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Selected date outside the calendar", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            performSegue(withIdentifier: "addUserEvent", sender: nil)
        }
    }
    
    func compare1(date:String) -> Bool{
        let s = self.formatter1.string(from: selectedDate).components(separatedBy: "-")
        let e = date.components(separatedBy: "-")
        if Int(s[0])! < Int(e[0])! {
            return true
        } else if Int(s[0])! == Int(e[0])!{
            if Int(s[1])! < Int(e[1])! {
                return true
            } else if Int(s[1])! == Int(e[1])! {
                if Int(s[2])! < Int(e[2])! {
                    return true
                } else if Int(s[2])! == Int(e[2])! {
                    return true
                } else {
                    return false
                }
                
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func compare2(date:String) -> Bool{
        let s = self.formatter1.string(from: selectedDate).components(separatedBy: "-")
        let e = date.components(separatedBy: "-")
        if Int(s[0])! < Int(e[0])! {
            return true
        } else if Int(s[0])! == Int(e[0])!{
            if Int(s[1])! < Int(e[1])! {
                return true
            } else if Int(s[1])! == Int(e[1])! {
                if Int(s[2])! < Int(e[2])! {
                    return true
                } else if Int(s[2])! == Int(e[2])! {
                    return false
                } else {
                    return false
                }
                
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func fetchEvents(){
        list = []
        Database.database().reference().child("events").child((user.uid)!).child(curCal.name!).child(self.formatter1.string(from: selectedDate)).removeAllObservers()
        Database.database().reference().child("events").child((user.uid)!).child(curCal.name!).child(self.formatter1.string(from: selectedDate)).observe(.childAdded) { (snapshot) in
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
        self.tableView.reloadData()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        print(curCal.endDate!)
        return self.formatter.date(from: curCal.endDate!)!
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: curCal.startDate!)!
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventTableCell = self.tableView.dequeueReusableCell(withIdentifier: "eventCell") as! EventTableCell!
        cell.startTime.text = list[indexPath.row].startTime
        cell.endTime.text = list[indexPath.row].endTime
        
        if list[indexPath.row].with == Auth.auth().currentUser?.uid{
            cell.with.text = "With you"
            cell.eventTitle.text = self.list[indexPath.row].title
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addUserEvent") {
            let addVC = segue.destination as! UserAddEventVC
            addVC.user = self.user
            addVC.curCal = self.curCal
            addVC.selectedDate = self.selectedDate
            addVC.list = self.list
        }
    }
}
