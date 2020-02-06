//
//  EditProfileViewController.swift
//  ProductsApp
//
//  Created by developer on 18.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase

class EditProfileViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var fullNameTextField: AuthenticationTextField!
    @IBOutlet weak var emailTextField: AuthenticationTextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var addNewImageButton: UIButton!
    
    // MARK: - Properties
    
    private var user: UserModel? {
        didSet {
            guard let user = user else { return }
            fillUI(fromUser: user)
        }
    }
    private var imagePicker: UIImagePickerController!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupImagePicker()
        getUserInfo()
    }
    
    // MARK: - Private methods
    
    private func setupImagePicker() {
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profilePicture.isUserInteractionEnabled = true
        profilePicture.addGestureRecognizer(imageTap)
        profilePicture.layer.cornerRadius = profilePicture.bounds.height / 2
        profilePicture.clipsToBounds = true
        
        addNewImageButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController() // TODO: - Add Camera
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func setupUI() {
        profilePicture.layer.cornerRadius = profilePicture.bounds.height / 2
        profilePicture.clipsToBounds = true
        emailTextField.delegate = self
        fullNameTextField.delegate = self
    }
    
    private func fillUI(fromUser user: UserModel) {
        fullNameTextField.text = user.fullName
        emailTextField.text = user.email
        profilePicture.setImage(url: URL(string: user.imageURL))
    }
    
    // MARK: - Web Services
    
    func getUserInfo() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseAPI.instance.getUser(uid: uid) { (user) in
            self.user = user
        }
    }
    
    private func updateEmail(email: String) {
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            if let error = error {
                print(error)
            } else {
                self.user?.email = email
                print("CHANGED")
            }
        }
    }
    
    private func updateUser(_ user: UserModel, picture: UIImage) {
        FirebaseAPI.instance.updateProfile(user: user, image: picture) { (error) in
            self.hideProgressHUD()
            self.showAlert(title: "Update Completed", message: "You successfuly update your profile!")
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        showProgressHUD()
        
        guard let user = user, let picture = profilePicture.image else { return }
        updateUser(user, picture: picture)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profilePicture.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        switch textField {
        case fullNameTextField:
            user?.fullName = text
        case emailTextField:
            updateEmail(email: text)
        default: break
        }
    }
}

