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

class UserAddEventVC: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var descrTF: UITextField!
    @IBOutlet weak var startTimeTF: UITextField!
    @IBOutlet weak var endTimeTF: UITextField!
    
    var selectedDate: Date!
    var curCal: TTCalendar!
    var user = User()
    var event = Event()
    var list: Array<Event> = Array()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "UserSelCal") {
            let selVC = segue.destination as! UserSelCalVC
            selVC.user = self.user
            selVC.curCal = self.curCal
            selVC.selectedDate = self.selectedDate
            selVC.event = self.event
            selVC.vc = self
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        let newEvent = Event(title: titleTF.text!, descr: descrTF.text!, startTime: startTimeTF.text!, endTime: endTimeTF.text!)
        self.event = newEvent
        addEvent()
    }
    
    public func addEvent(){
        if(titleTF.text != "" && descrTF.text != "" && startTimeTF.text != "" && endTimeTF.text != ""){
            if compare(){
                if checkTime(){
                    performSegue(withIdentifier: "UserSelCal", sender: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "An event is already set for this time", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
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
    
    func checkTime()->Bool{
        for event in list{
            if ((toMin(str: event.startTime!) <= toMin(str: startTimeTF.text!))&&(toMin(str: event.endTime!) >= toMin(str: startTimeTF.text!))){
                return false
            }
            if ((toMin(str: event.startTime!) <= toMin(str: endTimeTF.text!))&&(toMin(str: event.endTime!) >= toMin(str: endTimeTF.text!))) {
                return false
            }
            if ((toMin(str: startTimeTF.text!) <= toMin(str: event.startTime!))&&(toMin(str: endTimeTF.text!) >= toMin(str: event.startTime!))){
                return false
            }
            if ((toMin(str: startTimeTF.text!) <= toMin(str: event.endTime!))&&(toMin(str: endTimeTF.text!) >= toMin(str: event.endTime!))) {
                return false
            }
        }
        return true
    }
    
    func toMin(str: String)-> Int{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let time = formatter.date(from: str)
        formatter.dateFormat = "hh:mm"
        let start = formatter.string(from: time!)
        let s = start.components(separatedBy: ":")
        let Min = Int(s[0])!*60 + Int(s[1])!
        return Min
    }
    
    func compare() -> Bool{
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let stime = formatter.date(from: startTimeTF.text!)
        let etime = formatter.date(from: endTimeTF.text!)
        formatter.dateFormat = "hh:mm"
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

