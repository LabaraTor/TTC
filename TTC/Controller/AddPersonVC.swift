//
//  AddPersonVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 17.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class AddPersonVC: UIInputViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var list: Array<User> = Array()
    static var selUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUsers()
        tableView.delegate = self
        tableView.dataSource = self
        let sc = UISearchController(searchResultsController: nil)
        if #available(iOS 11.0, *) {
            self.navigationItem.searchController = sc
        } else {
            // Fallback on earlier versions
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func fetchUsers() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]{
                let user = User()
                user.Nickname = dictionary["Nickname"] as? String
                user.ProfileImgURL = dictionary["ProfileImgURL"] as? String
                user.uid = snapshot.key
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
        let user = list[indexPath.row]
        AddPersonVC.selUser = user
        self.dismiss(animated: true, completion: nil)
    }}
