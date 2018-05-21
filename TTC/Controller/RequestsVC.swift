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
    
    var inpReq = InputRequest()
    
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
        let req = list[indexPath.row]
        cell.title.text = req.title
        cell.nickname.text = req.uid
        cell.date.text = req.date
        cell.descr.text = req.descr
        cell.starttime.text = req.startTime
        cell.endtime.text = req.endTime
        
        let uid = req.uid
        Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                cell.nickname.text = dictionary["Nickname"] as? String
                //set image
                let url = URL(string: dictionary["ProfileImgURL"] as! String)
                let request = URLRequest(url:url!)
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error != nil{
                        self.present(Lib.showError(error: error!), animated: true, completion: nil)
                    }
                    
                    DispatchQueue.main.async{
                        if let image = UIImage(data: data!){
                            cell.ProfileImage.image = image
                        }
                    }
                    }.resume()
            }
        }, withCancel: nil)
        
        cell.ButtonHandler = {()-> Void in
            self.inpReq = self.list[indexPath.row]
        }
        cell.CancelButtonHandler = {()-> Void in
            self.inpReq = self.list[indexPath.row]
            self.delReq()
        }
        return cell
    }
    
    func delReq(){
        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
        ref.child("requests").child((Auth.auth().currentUser?.uid)!).child("input").child(inpReq.title!).setValue(nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 221
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "selReqCal") {
            let scVC = segue.destination as! SelCalVC
            scVC.inpReq = inpReq
        }
    }
}
