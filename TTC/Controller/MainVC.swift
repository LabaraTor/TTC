//
//  MainVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!

    @IBOutlet weak var Nickname: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchCalendars()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            self.performSegue(withIdentifier: "SignOut", sender: self)
        }else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    self.Nickname.text = dictionary["Nickname"] as? String
                    self.setProfileImage(profileImageUrl: dictionary["ProfileImgURL"] as! String)
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
                }
            }
        }.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func SignOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "SignOut", sender: self)
    }
    
    func fetchCalendars(){
        Database.database().reference().child("calendars").child((Auth.auth().currentUser?.uid)!).observe(.childAdded) { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: AnyObject]{
                print(dictionary)
                let name = dictionary["name"] as? String
                let startDate = dictionary["startDate"] as? String
                let endDate = dictionary["endDate"] as? String
                let close = dictionary["close"] as? String
                let calendar = TTCalendar(name: name!, startDate: startDate!, endDate: endDate!, close: close!)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a new cell if needed or reuse an old one
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CallTableCell!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "SelCal", sender: self)
    }
    
}
