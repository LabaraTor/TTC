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
    
    func fetchRequests() {
        Database.database().reference().child("requests").child((Auth.auth().currentUser?.uid)!).child("input").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let request = InputRequest()
                request.title = dictionary["title"] as? String
                request.descr = dictionary["descr"] as? String
                request.uid = dictionary["uid"] as? String
                request.startTime = dictionary["startTime"] as? String
                request.endTime = dictionary["endTime"] as? String
                self.list.append(request)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }

}
