//
//  AddCalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 11.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class AddCalVC: UIViewController {

    @IBOutlet weak var calName: UITextField!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    @IBOutlet weak var descrField: UITextField!
    @IBOutlet weak var switcher: UISwitch!
    
    let picker = UIDatePicker()
    
    var sdate = String()
    var edate = String()
    
    @IBAction func Add(_ sender: Any) {
        if(calName.text != "" && startField.text != "" && endField.text != "" && descrField.text != ""){
            if(compare()){
                var close: String
                if switcher.isOn{
                    close =  "true"
                } else {
                    close = "false"
                }
                let newCal = TTCalendar(name: calName.text!, startDate: startField.text!, endDate: endField.text!, close: close)
                newCal.descr = descrField.text!
                addCal(newCal: newCal)
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "The end date must be later than the start date", preferredStyle: UIAlertControllerStyle.alert)
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
        let s = sdate.components(separatedBy: "-")
        let e = edate.components(separatedBy: "-")
        if Int(s[0])! < Int(e[0])! {
            return true
        } else if Int(s[0])! == Int(e[0])!{
            if Int(s[1])! < Int(e[1])! {
                return true
            } else if Int(s[1])! == Int(e[1])! {
                if Int(s[2])! < Int(e[2])! {
                    return true
                } else if Int(s[2])! == Int(e[2])! {
                    return true
                } else {
                    return false
                }

            } else {
                return false
            }
        } else {
            return false
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createDatePicker()
        createDatePicker1()
    }
    
    func createDatePicker() {        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(SDonePressed))
        toolbar.setItems([done], animated: false)
        
        startField.inputAccessoryView = toolbar
        startField.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "en")
    }
    
    @objc func SDonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en")
        let dateString = formatter.string(from: picker.date)
        formatter.dateFormat = "yyyy-MM-dd"
        self.sdate = formatter.string(from: picker.date)
        
        startField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    func createDatePicker1() {        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // done button for toolbar
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(EDonePressed))
        toolbar.setItems([done], animated: false)
        
        endField.inputAccessoryView = toolbar
        endField.inputView = picker
        
        // format picker for date
        picker.datePickerMode = .date
        picker.locale = Locale(identifier: "en")
    }
    
    @objc func EDonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en")
        let dateString = formatter.string(from: picker.date)
        formatter.dateFormat = "yyyy-MM-dd"
        self.edate = formatter.string(from: picker.date)
        
        endField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    
    public func addCal(newCal: TTCalendar){
        let values = ["name":newCal.name, "startDate":newCal.startDate, "endDate":newCal.endDate, "close":newCal.close, "descr":newCal.descr] as [String : AnyObject]
        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
        let calsReference = ref.child("calendars").child((Auth.auth().currentUser?.uid)!).child(newCal.name!)
        calsReference.updateChildValues(values) { (error, ref) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }

    
}
