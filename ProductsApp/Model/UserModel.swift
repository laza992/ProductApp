//
//  UserModel.swift
//  ProductsApp
//
//  Created by developer on 18.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class UserModel {
    var fullName: String
    var email: String
    var imageURL: String
    var dateOfBirth: TimeInterval?
    var uid: String
    
    var date: Date {
        return Date(timeIntervalSince1970: dateOfBirth ?? Date().timeIntervalSince1970)
    }
    
    init(fullName: String, email: String, imageURL: String, dateOfBirth: TimeInterval, uid: String) {
        self.fullName = fullName
        self.email = email
        self.imageURL = imageURL
        self.dateOfBirth = dateOfBirth
        self.uid = uid
    }
}
