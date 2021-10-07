//
//  LocalUser.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/22/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import Foundation
import RealmSwift

class LocalUser: Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var email: String = ""
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // Get the first object of User Model
    class func current() -> LocalUser? {
        let users = try! Realm().objects(LocalUser.self)
        return users.first
    }
    
    class func saveLoginData(user: User?) {
        guard (LocalUser.current() == nil) else {
            RealmService.shared.remove(objectsOfInstanceType: LocalUser.self) // Remove if exists
            self.createLocalUser(user: user) // Write user then
            return
        }
        
        self.createLocalUser(user: user) // Write user
    }
    
    class func createLocalUser(user: User?) {
        let newUser = LocalUser()
        newUser.id = user?._id ?? "0"
        newUser.email = user?.email ?? ""
        RealmService.shared.create(object: newUser)
    }

}
