//
//  AddCalVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 11.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import TextFieldEffects
import FirebaseDatabase
import FirebaseAuth

class AddCalVC: UIViewController {

    @IBOutlet weak var calName: HoshiTextField!
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endField: UITextField!
    
    let picker = UIDatePicker()
    
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
    }
    
    @objc func SDonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
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
    }
    
    @objc func EDonePressed() {
        // format date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let dateString = formatter.string(from: picker.date)
        
        endField.text = "\(dateString)"
        self.view.endEditing(true)
    }
    
    @IBAction func Cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Add(_ sender: Any) {
        let newCal = TTCalendar(name: calName.text!, startDate: startField.text!, endDate: endField.text!, close: "true");
        addCal(newCal: newCal)
        self.dismiss(animated: true, completion: nil)
    }
    
    public func addCal(newCal: TTCalendar){
        let values = ["name":newCal.name, "startDate":newCal.startDate, "endDate":newCal.endDate, "close":"true"] as [String : AnyObject]
        let ref = Database.database().reference(fromURL: "https://ttc0-f65c7.firebaseio.com/")
        let calsReference = ref.child("calendars").child((Auth.auth().currentUser?.uid)!).child(newCal.name!)
        calsReference.updateChildValues(values) { (error, ref) in
            if error != nil{
                self.present(Lib.showError(error: error!), animated: true, completion: nil)
            }
            self.dismiss(animated: true, completion: nil)
        }
        Lib.calList.append(newCal)
    }

    
}
