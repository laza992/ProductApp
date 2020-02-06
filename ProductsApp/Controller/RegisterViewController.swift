//
//  RegisterViewController.swift
//  ProductsApp
//
//  Created by developer on 12.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class RegisterViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameTextField: AuthenticationTextField!
    @IBOutlet weak var dateOfBirthTextField: AuthenticationTextField!
    @IBOutlet weak var emailTextField: AuthenticationTextField!
    @IBOutlet weak var passwordTextField: AuthenticationTextField!
    @IBOutlet weak var changeProfileImage: UIButton!
    
    // MARK: - Properties
    
    var imagePicker: UIImagePickerController!
    private let birthdateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.maximumDate = Date()
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(datePickerAction(_:)), for: .valueChanged)
        return picker
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getImagePicker()
        dateOfBirthTextField.inputView = datePicker
    }
    
    // MARK: - Private methods
    
    private func getImagePicker() {
        
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        changeProfileImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    private func authenticationCompletion() {
        let initialTabVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MainTab")
        let window = UIApplication.shared.windows.first!
        window.makeKeyAndVisible()
        window.rootViewController = initialTabVC
    }
    
    // MARK: - Selector methods
    
    @objc func openImagePicker(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func datePickerAction(_ sender: UIDatePicker) {
        dateOfBirthTextField.text = birthdateFormatter.string(from: sender.date)
    }
    
    // MARK: - Web Services
    
    private func saveImage(image: UIImage, uid: String, completion: @escaping(Error?) -> Void) {
        FirebaseAPI.instance.uploadProfilePhoto(uid: uid, image: image, completionHandler: completion)
    }
    
    private func signUpAPI(fullName: String, email: String, password: String, dateOfBirth: String, image: UIImage) {
        FirebaseAPI.instance.registerUser(fullName: fullName, withEmail: email, password: password, dateOfBirth: dateOfBirth, image: profileImageView.image!) { (error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                self.saveImage(image: image, uid: Auth.auth().currentUser!.uid) { (error) in
                    if let error = error {
                        self.showAlert(message: error.localizedDescription)
                    } else {
                        self.dismiss(animated: true, completion: nil)
                        self.authenticationCompletion()
                    }
                }
            }
        }
    }

    // MARK: - Button Actions
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        guard let fullName = fullNameTextField.text?.trimmingCharacters(in: .whitespaces), fullName != "",
            let email = emailTextField.text?.trimmingCharacters(in: .whitespaces), email != "",
            let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces), password != "",
            let dateOfBirth = dateOfBirthTextField.text?.trimmingCharacters(in: .whitespaces), dateOfBirth != "",
            let image = profileImageView.image
            else {
                self.showAlert(message: "Please fill all fields!")
                return
        }
        showProgressHUD()
        
        signUpAPI(fullName: fullName, email: email, password: password, dateOfBirth: dateOfBirth, image: image)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profileImageView.image = pickedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
