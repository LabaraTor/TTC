//
//  MainVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser == nil{
            self.performSegue(withIdentifier: "SignOut", sender: self)
        }
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
