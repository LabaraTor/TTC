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
    @IBOutlet weak var ProfileImage: UIImageView!
    
    var user = User()
    var list = Array<TTCalendar>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Nickname.text = user.Nickname
        fetchCalendars()
        tableView.delegate = self
        tableView.dataSource = self
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = false
        } else {
            // Fallback on earlier versions
        }
        setProfileImage(profileImageUrl: user.ProfileImgURL!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchCalendars(){
        list = []
        Database.database().reference().child("calendars").child((user.uid)!).observe(.childAdded) { (snapshot) in
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
    
    func setProfileImage(profileImageUrl: String){
        let url = URL(string: profileImageUrl)
        let request = URLRequest(url:url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            
            DispatchQueue.main.async{
                if let image = UIImage(data: data!){
                    self.ProfileImage.image = image
                }
            }
            }.resume()
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CallTableCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CallTableCell!
        cell.name.text = list[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserCalVC.curCal = list[indexPath.row]
        performSegue(withIdentifier: "UserTableToCal", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
