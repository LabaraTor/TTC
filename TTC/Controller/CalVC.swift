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

class CalVC: UIViewController, FSCalendarDataSource, FSCalendarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var someview: UIView!
    
    var curCal: TTCalendar!
    var selectedDate: Date!
    
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
    
    fileprivate let formatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd,yyyy"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationItem.title = curCal?.name
        tableView.delegate = self
        tableView.dataSource = self
        selectedDate = calendar.today
        fetchEvents()
        self.view.addGestureRecognizer(self.scopeGesture)
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        let xPosition = tableView.frame.origin.x
        let yPosition = tableView.frame.origin.y - self.calendar.fs_height + bounds.height
        
        let height = tableView.frame.size.height
        let width = tableView.frame.size.width
        
        UIView.animate(withDuration: 1.0, animations: {
            
            self.tableView.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
            
        })
        self.tableView.frame.size.height += (self.calendar.fs_height - bounds.height)
        self.calendar.fs_height = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchEvents(){
        list = []
        Database.database().reference().child("events").child((Auth.auth().currentUser?.uid)!).child(curCal.name!).child(self.formatter1.string(from: selectedDate)).observe(.childAdded) { (snapshot) in
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

    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        fetchEvents()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
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
        let event = list[indexPath.row]
        cell.eventTitle.text = event.title
        cell.startTime.text = event.startTime
        cell.endTime.text = event.endTime

        if event.with != nil{
            Database.database().reference().child("users").child(event.with!).observeSingleEvent(of: .value, with: { (snapshot) in
                let eventDict = snapshot.value as! [String: Any]
                
                let with = eventDict["Nickname"] as! String
                cell.with.text = "With \(with)"
//                cell.descr.text = "With \(with)"
            })
        } else {
            cell.with.text = event.descr
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            Database.database().reference().child("events").child((Auth.auth().currentUser?.uid)!).child(curCal.name!).child(self.formatter1.string(from: selectedDate)).child(list[indexPath.row].title!).setValue(nil)
            list.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func Add(_ sender: Any) {
        if  selectedDate == calendar.today{
            let sdate = self.formatter2.date(from: curCal.startDate!)
            print(curCal.startDate!)
            let edate = self.formatter2.date(from: curCal.endDate!)
            let sDateStr = self.formatter1.string(from: sdate!)
            let eDateStr = self.formatter1.string(from: edate!)
            if (compare1(date: eDateStr) && !compare2(date: sDateStr)){
                performSegue(withIdentifier: "CalToAdd", sender: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Selected date outside the calendar", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            performSegue(withIdentifier: "CalToAdd", sender: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CalToAdd") {
            let addVC = segue.destination as! AddEventVC
            addVC.selectedDate = self.selectedDate
            addVC.curCal = self.curCal
        }
    }
}
