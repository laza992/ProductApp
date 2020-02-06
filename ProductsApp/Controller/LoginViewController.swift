//
//  LoginViewController.swift
//  ProductsApp
//
//  Created by developer on 12.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: BaseViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: AuthenticationTextField!
    @IBOutlet weak var passwordTextField: AuthenticationTextField!

    // MARK: Properties
    
    private let loginManager = FBSDKLoginManager()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Private methods
    
    private func authenticationCompletion() {
        let initialTabVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MainTab")
        let window = UIApplication.shared.windows.first!
        window.makeKeyAndVisible()
        window.rootViewController = initialTabVC
    }
    
    private func loginAPI(email: String, password: String) {
        FirebaseAPI.instance.loginUser(withEmail: email, andPassword: password) { (loginError) in
            if let loginError = loginError {
                self.showAlert(message: loginError.localizedDescription)
            } else {
                self.dismiss(animated: true, completion: nil)
                self.authenticationCompletion()
            }
        }
    }
    
    // MARK: - Facebook Web Services
    
    private func facebookLogin(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                self.getUserDetails(user: result!.user)
            }
        }
    }
    
    private func getUserDetails(user: User) {
        
        FacebookAPI.getFacebookUserData { [weak self] (fullName, imageURLString, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else if let fullName = fullName {
                let parameters: [String: Any] = ["name": fullName, "provider": user.providerID,
                                                 "profileImage": imageURLString ?? ""]
                
                FirebaseAPI.instance.updateUserInfo(uid: user.uid, parameters: parameters) { (error) in
                    if let error = error {
                        self.showAlert(message: error.localizedDescription)
                    } else {
                        self.authenticationCompletion()
                    }
                }
            } else {
                self.showAlert(message: "Problem with getting user info from facebook")
            }
        }
    }
    
    //MARK: - Button Actions
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), email != "",
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces), password != ""
            else {
            self.showAlert(message: "Please fill all fields!")
            return
        }
        showProgressHUD()
        loginAPI(email: email, password: password)
    }
    
    @IBAction func facebookButtonPressed(_ sender: Any) {
        
        loginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else if result!.isCancelled {
                self.showAlert(message: "Facebook was canceled!")
            } else {
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.facebookLogin(credential)
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
}


