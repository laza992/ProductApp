//
//  MealDetailViewController.swift
//  ProductsApp
//
//  Created by developer on 13.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase

class MealDetailViewController: UIViewController {

    // MARK: - Properties
    
    var product: Products!
    
    private let formatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    // MARK: - Outlets
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var mealNameLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillUI()
        getUserFullname()
    }
    
    // MARK: - Private methods
    
    private func fillUI() {
        mealImage.setImage(url: URL(string: product.imageURLString))
        priceLabel.text = "$\(product.price)"
        mealNameLabel.text = product.name
        datePostedLabel.text = formatter.string(from: product.date)
    }
    
    // MARK: - Web Services
    
    private func getUserFullname() {
        FirebaseAPI.instance.getUser(uid: product.userUid) { (user) in
            self.fullNameLabel.text = user.fullName
        }
    }
}
