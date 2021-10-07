//
//  AddReminderVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/23/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit
import UserNotifications

class AddReminderVC: UIViewController {
    
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtBody: UITextField!
    @IBOutlet weak var datePickerReminder: UIDatePicker!
    var id = ""
    var taskName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTitle.text = taskName
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTappedOnSave(_ sender: Any) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.badge,.sound], completionHandler: {succes,err in
            if succes{
                DispatchQueue.main.async {
                    self.shaduleReminder()
                }
            }else{
                AlertProvider(vc: self).showAlert(title: "Error", message: err?.localizedDescription ?? "Error Occured", action: AlertAction(title: "Dismiss"))
            }
        })
    }
    
    func shaduleReminder(){
        if (!txtTitle.text!.isEmpty && !txtBody.text!.isEmpty){
            let content = UNMutableNotificationContent()
            content.title = txtTitle.text!
            content.body = txtBody.text!
            content.sound = .default
            
            Reminders.createReminder(reminder: Reminder(title: txtTitle.text!, body: txtBody.text!, date: datePickerReminder.date, id: id))
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: datePickerReminder.date), repeats: false)
            let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                if (error != nil) {
                    AlertProvider(vc: self).showAlert(title: "Error", message: error?.localizedDescription ?? "Error Occured", action: AlertAction(title: "Dismiss"))
                }else{
                    DispatchQueue.main.async {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
