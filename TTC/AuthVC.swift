//
//  ViewController.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FirebaseAuth
import SkyFloatingLabelTextField
import Firebase

class AuthVC: UIViewController {

    @IBOutlet weak var LogTF: SkyFloatingLabelTextField!
    @IBOutlet weak var PasTF: SkyFloatingLabelTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            let alert = UIAlertController(title: "Sign In", message: "Success", preferredStyle: UIAlertControllerStyle.alert)
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }

    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: LogTF.text!, password: PasTF.text!) { (user, error) in
            if let user = user {
                let alert = UIAlertController(title: "Sign In", message: "\(user.uid)", preferredStyle: UIAlertControllerStyle.alert)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

