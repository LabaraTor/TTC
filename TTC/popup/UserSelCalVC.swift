//
//  UserSelCalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 18.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase

class UserSelCalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedDate: Date!
    var curCal: TTCalendar!
    var user = User()
    var event = Event()
    var list: Array<TTCalendar> = Array()
    var vc = UserAddEventVC()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        newList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func newList(){
        for cal in MainVC.list {
            let e1 = self.formatter2.date(from: cal.endDate!)
            let e2 = self.formatter1.string(from: e1!)
            let s1 = self.formatter2.date(from: cal.startDate!)
            let s2 = self.formatter1.string(from: s1!)
            if (compare1(date: e2) && !compare2(date: s2)){
                list.append(cal)
            }
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelCalCell = self.tableView.dequeueReusableCell(withIdentifier: "selCalCell") as! SelCalCell!
        cell.title.text = list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let values1 = ["title":event.title, "descr":event.descr, "startTime":event.startTime, "endTime":event.endTime, "with":user.uid] as [String : AnyObject]
        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
        let calsReference1 = ref.child("events").child((Auth.auth().currentUser?.uid)!).child(list[indexPath.row].name!).child(self.formatter.string(from: selectedDate)).child(event.title!)
        calsReference1.updateChildValues(values1) { (error, ref) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
        }
        
        
        let values2 = ["title":event.title, "descr":event.descr, "startTime":event.startTime, "endTime":event.endTime, "with":Auth.auth().currentUser?.uid] as [String : AnyObject]
        let calsReference2 = ref.child("events").child(user.uid!).child(curCal.name!).child(self.formatter.string(from: selectedDate)).child(event.title!)
        calsReference2.updateChildValues(values2) { (error, ref) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
            self.vc.dismiss(animated: true, completion: nil)
        }
    }
}

