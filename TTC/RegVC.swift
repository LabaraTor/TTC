//
//  RegVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 06.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import FirebaseAuth
import Firebase
import FirebaseDatabase
import FirebaseStorage

class RegVC: UIViewController{

    @IBOutlet weak var ProfileIMG: UIImageView!
    
    @IBOutlet weak var NickTF: SkyFloatingLabelTextField!
    @IBOutlet weak var EmailTF: SkyFloatingLabelTextField!
    @IBOutlet weak var PasTF1: SkyFloatingLabelTextField!
    @IBOutlet weak var PasTF2: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ProfileIMG.layer.cornerRadius = ProfileIMG.frame.height/2
        ProfileIMG.clipsToBounds = true
        
        
        NickTF.placeholder = "Enter nickname"
        NickTF.title = "Nickname"

        EmailTF.placeholder = "Enter email"
        EmailTF.title = "Email"
        
        PasTF1.placeholder = "Enter password"
        PasTF1.title = "Password"
        
        PasTF2.placeholder = "Confirm password"
        PasTF2.title = "Password"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func RegTap(_ sender: Any) {
        Auth.auth().createUser(withEmail: EmailTF.text!, password: PasTF1.text!) { (user, error) in
            if let error = error{
                self.present(Lib.showError(error: error), animated: true, completion: nil)
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName)")

            if let uploadData = UIImagePNGRepresentation(self.ProfileIMG.image!){
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if let error = error{
                        self.present(Lib.showError(error: error), animated: true, completion: nil)
                    }
                    
                    storageRef.downloadURL(completion: { (url, error) in
                        if error != nil{
                            self.present(Lib.showError(error: error!), animated: true, completion: nil)
                        }
                        let values = ["Nickname":self.NickTF.text!, "ProfileImgURL": url?.absoluteString] as [String : AnyObject]
                        self.RegUser(uid: uid, values: values)
                    })
                })
            }
        }
    }
    
    private func RegUser(uid: String, values: [String:AnyObject]){
        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values) { (error, ref) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension RegVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func AddPhoto(_ sender: Any) {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            ProfileIMG.image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            ProfileIMG.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
}
