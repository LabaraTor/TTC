//
//  MainVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MainVC: UIViewController {

    @IBOutlet weak var Nickname: UILabel!
    @IBOutlet weak var ProfileImage: UIImageView!
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func cancel(_ sender: Any) {
        self.performSegue(withIdentifier: "SignOut", sender: self)
    }
    
    
}
