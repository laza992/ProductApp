//
//  ProductsViewController.swift
//  ProductsApp
//
//  Created by developer on 13.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKLoginKit

class ProductsViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var productArray = [Products]()
    
    // MARK: - Lifecylce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getAllProducts()
    }

    // MARK: - Private methods
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        showProgressHUD()
    }
    
    // MARK: - Web Services
    
    private func getAllProducts() {
        FirebaseAPI.instance.getAllProducts { (returnedProductArray) in
            self.productArray = returnedProductArray.sorted(by: { $0.date > $1.date })
            self.tableView.reloadData()
            self.hideProgressHUD()
        }
    }
    
    private func deleteProductAPI(_ product: Products) {
        FirebaseAPI.instance.deleteProduct(product.uid) { (error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                self.showAlert(message :"Product successfully deleted!")
            }
        }
    }
}
    //MARK: - Extensions

extension ProductsViewController: ProductCellDelegate {
    
    func editProduct(indexPath: IndexPath) {
        let product = productArray[indexPath.row]
        let uid = Auth.auth().currentUser?.uid
        
        if product.userUid == uid {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "EditProductViewController") as! EditProductViewController
            editVC.product = product
            self.navigationController?.pushViewController(editVC, animated: true)
            
        } else {
            self.showAlert(message :"You can't edit product!")
        }
    }
}

extension ProductsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductsCell", for: indexPath) as? ProductsCell else {
            return UITableViewCell()
        }
        
        let product = productArray[indexPath.row]
        cell.configureCell(product: product, indexPath: indexPath, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "MealDetailViewController") as! MealDetailViewController
        let product = productArray[indexPath.row]
        detailVC.product = product
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let product = productArray[indexPath.row]
        let uid = Auth.auth().currentUser?.uid
        
        if product.userUid == uid {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let product = productArray[indexPath.row]
        deleteProductAPI(product)
    }
}

