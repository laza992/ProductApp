//
//  Products.swift
//  ProductsApp
//
//  Created by developer on 14.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import UIKit

class Products {
    var name: String
    var price: String
    var imageURLString: String
    var date: Date
    var uid: String
    var userUid: String
    
    init(name: String, price: String, mealImage: String, date: Date, uid: String, userUid: String) {
        self.name = name
        self.price = price
        self.imageURLString = mealImage
        self.date = date
        self.uid = uid
        self.userUid = userUid
    }
}
