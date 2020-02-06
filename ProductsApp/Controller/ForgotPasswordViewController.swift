//
//  ForgotPasswordViewController.swift
//  ProductsApp
//
//  Created by developer on 13.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ForgotPasswordViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var emailTextField: AuthenticationTextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Web Services
    
    private func forgotPassworAPI(email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error{
                self.showAlert(message: error.localizedDescription)
            } else {
                self.showAlert(title: "Password Reset!", message: "You successfuly reset your password, please check your emal!") {
                    let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController
                    let window = UIApplication.shared.windows.first!
                    window.makeKeyAndVisible()
                    window.rootViewController = loginVC
                }
            }
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), email != "" else {
            self.showAlert(message: "Please enter your email")
            return
        }
        showProgressHUD()
        forgotPassworAPI(email: email)
    }
}
