//
//  MyProfileViewController.swift
//  ProductsApp
//
//  Created by developer on 18.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class MyProfileViewController: BaseViewController {

    // MARK: -Outlets
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    
    private var productArray: [Products] = []
    var user: UserModel? {
        didSet {
            guard let user = user else { return }
            fillUI(fromUser: user)
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getUserInfo()
        getAllProducts()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        showProgressHUD()
        profilePicture.layer.cornerRadius = profilePicture.bounds.height / 2
        profilePicture.clipsToBounds = true
    }
    
    private func fillUI(fromUser user: UserModel) {
        fullNameLabel.text = user.fullName
        emailLabel.text = user.email
        profilePicture.setImage(url: URL(string: user.imageURL))
    }
    
    // MARK: - Web Services
    
    private func getUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseAPI.instance.getUser(uid: uid) { [weak self] (user) in
            guard let self = self else { return }
            self.user = user
        }
    }
    
    private func getAllProducts() {
        FirebaseAPI.instance.getAllProducts { (returnedProducts) in
            self.productArray = returnedProducts.sorted(by: { $0.date > $1.date })
            self.productArray = self.productArray.filter({ $0.userUid == Auth.auth().currentUser?.uid })
            self.tableView.reloadData()
            self.hideProgressHUD()
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        yesNoAction(title: "Logout", message: "Are you sure you want to logout?", leftButtonTitle: "No", rightButtonTitle: "Yes", yesCompletion: {
            do {
                try Auth.auth().signOut()
                FBSDKLoginManager().logOut()
                let authVC = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
                self.present(authVC!, animated: true, completion: nil)
            } catch {
                print(error)
            }
        })
    }
}

// MARK: - Extensions

extension MyProfileViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell") as? MyProfileCell else {
            return UITableViewCell()
        }
        let product = productArray[indexPath.row]
        cell.configureCell(product: product)
        return cell
    }
    
    
}
