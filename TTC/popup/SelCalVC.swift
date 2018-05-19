//
//  SelCalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 18.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase

class SelCalVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    static var inpReq = InputRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return MainVC.list.count
        // ЗАФЕТЧИТЬ КАЛЕНДАРИ!!!!!!!
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SelCalCell = self.tableView.dequeueReusableCell(withIdentifier: "selCalCell") as! SelCalCell!
//        cell.title.text = MainVC.list[indexPath.row].name
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let inpReq = SelCalVC.inpReq
//        let values = ["title":inpReq.title, "descr":inpReq.descr, "startTime":inpReq.startTime, "endTime":inpReq.endTime, "with":inpReq.uid] as [String : AnyObject]
//        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
//        let calsReference = ref.child("events").child((Auth.auth().currentUser?.uid)!).child(MainVC.list[indexPath.row].name!).child(inpReq.date!).child(inpReq.title!)
//        calsReference.updateChildValues(values) { (error, ref) in
//            if error != nil{
//                self.present(Lib.showError(error: error!), animated: true, completion: nil)
//            }
//            
//            self.dismiss(animated: true, completion: nil)
//        }
//        ref.child("requests").child((Auth.auth().currentUser?.uid)!).child("input").child(inpReq.title!).setValue(nil)
//    }
}
