//
//  MainVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    var list: Array<TTCalendar> = Array()

    @IBOutlet weak var Nickname: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProfileImage.layer.masksToBounds = false
        ProfileImage.layer.cornerRadius = ProfileImage.frame.size.width / 2
        ProfileImage.clipsToBounds = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        load()
    }
    
    func load() {
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show()
        if Auth.auth().currentUser == nil{
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "SIgnOutFromMain", sender: self)
        }else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.Nickname.text = dictionary["Nickname"] as? String
                    self.setProfileImage(profileImageUrl: dictionary["ProfileImgURL"] as! String)
                    self.fetchCalendars()
                }
            }, withCancel: nil)
        }
    }
    
    func setProfileImage(profileImageUrl: String){
        let url = URL(string: profileImageUrl)
        let request = URLRequest(url:url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            
            DispatchQueue.main.async{
                if let image = UIImage(data: data!){
                    self.imageCache.setObject(image, forKey: url as AnyObject)
                    self.ProfileImage.image = image
                    SVProgressHUD.dismiss()
                }
            }
        }.resume()
    }
    
    @IBAction func SignOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "SIgnOutFromMain", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchCalendars(){
        list = []
        Database.database().reference().child("calendars").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value) { (snapshot) in
            if (snapshot.value! as? [String: AnyObject] == nil) {
                self.tableView.reloadData()
            }
        }
        Database.database().reference().child("calendars").child((Auth.auth().currentUser?.uid)!).observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let calendar = TTCalendar()
                calendar.name = dictionary["name"] as? String
                calendar.startDate = dictionary["startDate"] as? String
                calendar.endDate = dictionary["endDate"] as? String
                calendar.close = dictionary["close"] as? String
                calendar.descr = dictionary["descr"] as? String
                self.list.append(calendar)
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CallTableCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CallTableCell!
        
        let curCal = list[indexPath.row]
        cell.name.text = curCal.name
        cell.startDate.text = curCal.startDate
        cell.endDate.text = curCal.endDate
        cell.descr.text = curCal.descr ?? "Some info"
        if curCal.close == "true"{
            cell.locked.image = UIImage(named: "locked")!
        } else {
            cell.locked.image = UIImage(named: "unlocked")!
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SelCal", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "SelCal") {
            CalVC.curCal = list[(self.tableView.indexPathForSelectedRow?.row)!]
        }
        if (segue.identifier == "SIgnOutFromMain"){
            let navAuthVC = segue.destination as! NavAuthVC
            let authVC = navAuthVC.viewControllers.first as! AuthVC
            authVC.mainVC = self
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete){
            Database.database().reference().child("calendars").child((Auth.auth().currentUser?.uid)!).child(list[indexPath.row].name!).setValue(nil)
            list.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
}
