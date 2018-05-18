//
//  UserVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 18.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var Nickname: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    static var user = User()
    var list = Array<TTCalendar>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Nickname.text = UserVC.user.Nickname
        fetchCalendars()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchCalendars(){
        list = []
        Database.database().reference().child("calendars").child((UserVC.user.uid)!).observe(.childAdded) { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                if  dictionary["close"] as? String == "false"{
                    let calendar = TTCalendar()
                    calendar.name = dictionary["name"] as? String
                    calendar.startDate = dictionary["startDate"] as? String
                    calendar.endDate = dictionary["endDate"] as? String
                    calendar.close = dictionary["close"] as? String
                    self.list.append(calendar)
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UserCalCell = self.tableView.dequeueReusableCell(withIdentifier: "UserCalCell") as! UserCalCell!
        cell.Nickname.text = list[indexPath.row].name
        return cell
    }
}
