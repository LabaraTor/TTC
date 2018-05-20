//
//  SearchVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 14.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var list: Array<User> = Array()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 11.0, *) {
            let sc = UISearchController(searchResultsController: nil)
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.searchController = sc
        } else {
            // Fallback on earlier versions
        }
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.uid = snapshot.key
                user.Nickname = dictionary["Nickname"] as? String
                user.ProfileImgURL = dictionary["ProfileImgURL"] as? String
                self.list.append(user)
                self.tableView.reloadData()
            }
        }, withCancel: nil)
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchTableCell = self.tableView.dequeueReusableCell(withIdentifier: "searchCell") as! SearchTableCell!
        cell.nickName.text = list[indexPath.row].Nickname
        if let profileImageURL = list[indexPath.row].ProfileImgURL{
            cell.profileImage.setProfileImage(profileImageUrl: profileImageURL)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserVC.user = list[indexPath.row]
        performSegue(withIdentifier: "searchToUser", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
