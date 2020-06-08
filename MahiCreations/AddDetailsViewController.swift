//
//  AddDetailsViewController.swift
//  MahiCreations
//
//  Created by k.chinnababu on 07/06/20.
//  Copyright © 2020 Mahi Info services. All rights reserved.
//

import UIKit
import  CoreData

class AddDetailsViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var price: UITextField!
    
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var startDate: UITextField!
    @IBOutlet weak var channelName: UITextField!
    var currentTextField: UITextField!
    
    var picker = UIDatePicker()
    var managedObjectContext: NSManagedObjectContext? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(handleDatePicker), for: UIControl.Event.valueChanged)
    }

    @IBAction func createNewChannel(_ sender: Any) {
        let context = NSManagedObjectContext.newChildContext()
        let channel = OTTDetails.createObject(inContext:context)
        channel.channelName = self.channelName.text
        channel.price = self.price.text
        channel.startDate = self.startDate.text
        channel.endDate = self.endDate.text
        context.HMSave()
        self.navigationController?.popViewController(animated: true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        currentTextField = textField
        textField.inputView = picker
        return true
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.currentTextField.text = dateFormatter.string(from: picker.date)
        self.currentTextField.resignFirstResponder()
    }
}
