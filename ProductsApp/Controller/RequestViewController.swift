//
//  RequestViewController.swift
//  ProductsApp
//
//  Created by developer on 13.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class RequestViewController: BaseViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var mealImage: UIImageView!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var mealNameTextField: AuthenticationTextField!
    @IBOutlet weak var priceTextField: AuthenticationTextField!
    @IBOutlet weak var addNewImageButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    
    
    // MARK: - Properties
    
    private let date = Date()
    private let dateFormatter = DateFormatter()
    private var imagePicker: UIImagePickerController!
    private var cameraPicker: UIImagePickerController?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupImagePicker()
        dateFormat()
        getUserFullName()
    }
    
    // MARK: - Private methods
    
    private func dateFormat() {
        dateFormatter.dateStyle = .medium
        datePostedLabel.text = dateFormatter.string(from: Date())
    }
    
    private func resetUI() {
        mealImage.image = UIImage(named: "add-image")
        dateFormatter.dateStyle = .medium
        datePostedLabel.text = dateFormatter.string(from: Date())
        mealNameTextField.text = ""
        priceTextField.text = ""
        hideProgressHUD()
    }
    
    private func setupImagePicker() {
        
        mealImage.isUserInteractionEnabled = true
        mealImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openImagePicker)))
        mealImage.layer.cornerRadius = mealImage.bounds.height / 2
        mealImage.clipsToBounds = true
        
        addNewImageButton.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            self.showAlert(message: "Device doesn't have a camera")
            return
        }
        cameraPicker = UIImagePickerController()
        cameraPicker!.allowsEditing = true
        cameraPicker!.sourceType = .camera
        cameraPicker!.delegate = self
        
    }
    
    @objc func openImagePicker(_ sender: Any) {
        showCameraPhotoLibraryAlert(title: "Choose your source?", message: "", cameraCompletion: {
            if let cameraPicker = self.cameraPicker {
                self.present(cameraPicker, animated: true)
            }
        }) {
            self.present(self.imagePicker, animated: true)
        }
    }
    
    // MARK: - Web Services
    
    private func getUserFullName() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        FirebaseAPI.instance.getUser(uid: uid) { (user) in
            self.fullNameLabel.text = user.fullName
        }
    }
    
    // MARK: - Button Actions
    
    @IBAction func addNewMealButtonPressed(_ sender: Any) {
        
        guard let mealName = mealNameTextField.text, mealName.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let price = priceTextField.text, price.trimmingCharacters(in: .whitespacesAndNewlines) != "",
            let mealImage = mealImage.image
            else {
                showAlert(message: "Please fill all fields!")
                return
        }
        showProgressHUD()
        
        FirebaseAPI.instance.uploadPost(withMealName: mealName, andPrice: price, picture: mealImage) { (error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                self.resetUI()
                self.showAlert(title: "New Meal", message: "You successfully added new meal!")
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension RequestViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.mealImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
