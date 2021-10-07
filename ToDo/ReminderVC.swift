//
//  ReminderVC.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/23/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import UIKit

class ReminderVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var reminders:[Reminder] = []
    var savedReminders:[Reminders] = []
       
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getReminderData()
    }
    
    func getReminderData(){
       let reminders = Reminders.getReminders().toArray(ofType: Reminders.self)
        savedReminders = reminders
        for item in reminders {
            let title = item.title
            let body = item.body
            let date = item.date
            let id = item.id
            let newReminder = Reminder(title: title, body: body, date: date, id: id)
            self.reminders.append(newReminder)
        }
        tableView.reloadData()
    }

}

extension ReminderVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTVC",for: indexPath) as! ReminderTVC
        cell.configureCell(with: reminders[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            Reminders.deleteReminder(reminder: reminders[indexPath.row])
            reminders.remove(at: indexPath.row)
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [reminders[indexPath.row].id])
            tableView.reloadData()
        }
    }
    
}

public struct Reminder{
    var title:String
    var body:String
    var date: Date
    var id:String 
}
