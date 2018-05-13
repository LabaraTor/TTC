//
//  AddEventVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 13.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import TextFieldEffects
import Firebase
import FirebaseDatabase

class AddEventVC: UIViewController {

    @IBOutlet weak var titleTF: HoshiTextField!
    @IBOutlet weak var descrTF: HoshiTextField!
    @IBOutlet weak var startTimeTF: HoshiTextField!
    @IBOutlet weak var endTimeTF: HoshiTextField!
    
    @IBOutlet weak var addPeople: UIButton!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let newEvent = Event(title: titleTF.text!, descr: descrTF.text!, startTime: startTimeTF.text!, endTime: endTimeTF.text!)
        addEvent(newEvent: newEvent)
    }
    
    public func addEvent(newEvent: Event){
        let values = ["title":newEvent.title, "description":newEvent.descr, "startTime":newEvent.startTime, "endTime":newEvent.endTime] as [String : AnyObject]
        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
        let calsReference = ref.child("events").child((Auth.auth().currentUser?.uid)!).child(CalVC.curCal.name!).child(self.formatter.string(from: CalVC.selectedDate)).child(newEvent.title!)
        calsReference.updateChildValues(values) { (error, ref) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
