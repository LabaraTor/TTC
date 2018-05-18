//
//  RequestsVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 17.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RequestsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    
    var list: Array<InputRequest> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRequests()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    func fetchRequests() {
        Database.database().reference().child("requests").child((Auth.auth().currentUser?.uid)!).child("input").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let request = InputRequest()
                request.title = dictionary["title"] as? String
                request.descr = dictionary["descr"] as? String
                request.date = dictionary["date"] as? String
                request.uid = dictionary["uid"] as? String
                request.startTime = dictionary["startTime"] as? String
                request.endTime = dictionary["endTime"] as? String
                self.list.append(request)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
        Database.database().reference().child("requests").child((Auth.auth().currentUser?.uid)!).child("input").observe(.childRemoved, with: { (snapshot) in
            print("=====================")
            print(snapshot)
            print("=====================")
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let request = InputRequest()
                request.title = dictionary["title"] as? String
                request.descr = dictionary["descr"] as? String
                request.date = dictionary["date"] as? String
                request.uid = dictionary["uid"] as? String
                request.startTime = dictionary["startTime"] as? String
                request.endTime = dictionary["endTime"] as? String
                let newList = self.list.filter{
                    $0.title != request.title
                }
                self.list = newList
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }

        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ReqCell = self.tableView.dequeueReusableCell(withIdentifier: "reqCell") as! ReqCell!
        cell.title.text = list[indexPath.row].title
        cell.ButtonHandler = {()-> Void in
            SelCalVC.inpReq = self.list[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
}
