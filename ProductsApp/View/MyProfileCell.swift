//
//  MyProfileCell.swift
//  ProductsApp
//
//  Created by developer on 18.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

class MyProfileCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    //MARK: - Properties

    let formatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func configureCell(product: Products) {
        self.mealImage.setImage(url: URL(string: product.imageURLString))
        self.mealNameLabel.text = product.name
        self.datePostedLabel.text = formatter.string(from: product.date)
        self.priceLabel.text = "$\(product.price)"
    }
}

