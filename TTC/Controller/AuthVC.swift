//
//  ViewController.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class AuthVC: UIViewController {

    @IBOutlet weak var LogTF: UITextField!
    @IBOutlet weak var PasTF: UITextField!
    var handle: AuthStateDidChangeListenerHandle!
    var mainVC: MainVC!
    
    @IBOutlet weak var btn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        btn.layer.cornerRadius = btn.frame.height / 2.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.mainVC.viewDidLoad()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }

    @IBAction func SignIn(_ sender: Any) {
        Auth.auth().signIn(withEmail: LogTF.text!, password: PasTF.text!) { (user, error) in
            if let user = user {
                let alert = UIAlertController(title: "Sign In", message: "\(user.uid)", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
            if let error = error {
                self.present(Lib.showError(error: error), animated: true, completion: nil)
            }
        }
    }
    
}

