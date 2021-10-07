//
//  Reminders.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/24/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import Foundation
import RealmSwift

class Reminders: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
    @objc dynamic var date: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // Get the first object of User Model
    class func getReminders() -> Results<Reminders> {
        let users = try! Realm().objects(Reminders.self)
        return users
    }
 
    class func createReminder(reminder: Reminder?) {
        let newReminder = Reminders()
        newReminder.id = reminder?.id ?? "0"
        newReminder.date = reminder?.date ?? Date()
        newReminder.title = reminder?.title ?? ""
        newReminder.body = reminder?.body ?? ""
               
        RealmService.shared.create(object: newReminder)
    }
    
    
    class func deleteReminder(reminder: Reminder?){
        do {
            let realm = try Realm()
            
            if let obj = realm.objects(Reminders.self).filter("id = %@", reminder!.id).first {
                
                //Delete must be perform in a write transaction
                
                try! realm.write {
                    realm.delete(obj)
                }
            }
            
        } catch let error {
            print("error - \(error.localizedDescription)")
        }
    }
    
}
