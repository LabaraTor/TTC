//
//  AddEventVC.swift
//  TTC
//
//  Created by Торнике Двалашвили on 13.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit
import TextFieldEffects

class AddEventVC: UIViewController {

    @IBOutlet weak var titleTF: HoshiTextField!
    @IBOutlet weak var descrTF: HoshiTextField!
    @IBOutlet weak var startTimeTF: HoshiTextField!
    @IBOutlet weak var endTimeTF: HoshiTextField!
    
    @IBOutlet weak var addPeople: UIButton!
    
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
        Event.list.append(newEvent)
    }
}
