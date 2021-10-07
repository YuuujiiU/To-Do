//
//  User.swift
//  ToDo
//
//  Created by Pasan Induwara Edirisooriya on 11/22/20.
//  Copyright © 2020 Pasan. All rights reserved.
//

import Foundation

public struct User: Codable {
    
    public var _id: String?
    public var email: String?
    
    public init(_id: String?, email: String?) {
        self._id = _id
        self.email = email
    }
    
    public enum CodingKeys: String, CodingKey {
        case _id = "id"
        case email
    }
}
