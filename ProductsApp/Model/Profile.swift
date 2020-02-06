//
//  Profile.swift
//  ProductsApp
//
//  Created by developer on 18.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class UserModel {
    var userUid: String
    var imageURLString: String
    
    init(userUid: String, imageURLString: String) {
        self.userUid = userUid
        self.imageURLString = imageURLString
    }
}
