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

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descrTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    
    @IBOutlet weak var addPeople: UIButton!
    
    var selectedDate: Date!
    var curCal: TTCalendar!
    
    let picker = UIDatePicker()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        createDatePicker1()
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
        if(titleTF.text != "" && descrTF.text != "" && startTimeTF.text != "" && endTimeTF.text != ""){
            if compare(){
                let values = ["title":newEvent.title, "descr":newEvent.descr, "startTime":newEvent.startTime, "endTime":newEvent.endTime, "with":AddPersonVC.selUser?.uid] as [String : AnyObject]
                if AddPersonVC.selUser != nil{
                    let valuesReq = ["title":newEvent.title, "descr":newEvent.descr, "date":self.formatter.string(from: selectedDate), "startTime":newEvent.startTime, "endTime":newEvent.endTime, "uid":Auth.auth().currentUser?.uid] as [String : AnyObject]
                    let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
                    let reqReference = ref.child("requests").child((AddPersonVC.selUser?.uid)!).child("input").child(newEvent.title!)
                    reqReference.updateChildValues(valuesReq) { (error, ref) in
                        if error != nil{
                            self.present(Lib.showError(error: error!), animated: true, completion: nil)
                        }
                        self.dismiss(animated: true, completion: nil)
                    }
                }
                let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
                let calsReference = ref.child("events").child((Auth.auth().currentUser?.uid)!).child(curCal.name!).child(self.formatter.string(from: selectedDate)).child(newEvent.title!)
                calsReference.updateChildValues(values) { (error, ref) in
                    if error != nil{
                        self.present(Lib.showError(error: error!), animated: true, completion: nil)
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Error", message: "The end time must be later than the start time", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Error", message: "Fill in all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func compare() -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let stime = formatter.date(from: startTimeTF.text!)
        let etime = formatter.date(from: endTimeTF.text!)
        formatter.dateFormat = "HH:mm"
        let start = formatter.string(from: stime!)
        let end = formatter.string(from: etime!)
        let s = start.components(separatedBy: ":")
        let e = end.components(separatedBy: ":")
        let sMin = Int(s[0])!*60 + Int(s[1])!
        let eMin = Int(e[0])!*60 + Int(e[1])!
        return eMin >= sMin
    }
    
    func createDatePicker() {        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(SDonePressed))
        toolbar.setItems([done], animated: false)
        
        startTimeTF.inputAccessoryView = toolbar
        startTimeTF.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "en")
    }
    
    @objc func SDonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en")
        let dateString = formatter.string(from: picker.date)
        
        startTimeTF.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    func createDatePicker1() {        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(EDonePressed))
        toolbar.setItems([done], animated: false)
        
        endTimeTF.inputAccessoryView = toolbar
        endTimeTF.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .time
        picker.locale = Locale(identifier: "en")
    }
    
    @objc func EDonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "en")
        let dateString = formatter.string(from: picker.date)
        
        endTimeTF.text = "\(dateString)"
        self.view.endEditing(true)
    }
}
