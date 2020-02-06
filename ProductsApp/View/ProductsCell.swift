//
//  ProductsCell.swift
//  ProductsApp
//
//  Created by developer on 13.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase

protocol ProductCellDelegate {
    func editProduct(indexPath: IndexPath)
}

class ProductsCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    //MARK: - Properties
    
    let formatter: DateFormatter = {
       let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()
    
    var delegate: ProductCellDelegate?
    var indexPath: IndexPath!
    var product: Products!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func configureCell(product: Products, indexPath: IndexPath, delegate: ProductCellDelegate) {
        self.delegate = delegate
        if product.userUid == Auth.auth().currentUser?.uid {
            editButton.isHidden = false
        } else {
            editButton.isHidden = true
        }
        self.indexPath = indexPath
        self.mealImage.setImage(url: URL(string: product.imageURLString))
        self.mealNameLabel.text = product.name
        self.datePostedLabel.text = formatter.string(from: product.date)
        self.priceLabel.text = "$\(product.price)"
    }
    
    //MARK: - Button Actions
    
    @IBAction func editButtonPressed(_ sender: Any) {
        delegate?.editProduct(indexPath: indexPath)
    }
}
