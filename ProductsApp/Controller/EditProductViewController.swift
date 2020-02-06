//
//  EditProductViewController.swift
//  ProductsApp
//
//  Created by developer on 19.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import Firebase

class EditProductViewController: BaseViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var mealNameTextField: AuthenticationTextField!
    @IBOutlet weak var priceTextField: AuthenticationTextField!
    @IBOutlet weak var addNewImage: UIButton!
    
    // MARK: - Properties
    
    var product: Products!
    var imagePicker: UIImagePickerController!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        setupImagePicker()
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        productImage.layer.cornerRadius = productImage.bounds.height / 2
        productImage.clipsToBounds = true
        productImage.setImage(url: URL(string: product.imageURLString))
        priceTextField.text = "$\(product.price)"
        mealNameTextField.text = product.name
        
        mealNameTextField.isUserInteractionEnabled = true
        priceTextField.isUserInteractionEnabled = true
    }
    
    private func setupImagePicker() {
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(imageTap)
        productImage.layer.cornerRadius = productImage.bounds.height / 2
        productImage.clipsToBounds = true
        
        addNewImage.addTarget(self, action: #selector(openImagePicker), for: .touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func saveImage(image: UIImage, uid: String, completion: @escaping(Error?) -> Void) {
        FirebaseAPI.instance.uploadMealPhoto(uid: uid, image: image, completionHandler: completion)
    }
    
    //MARK: - Button Actions
    
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        switch sender {
        case mealNameTextField:
            product.name = text
        case priceTextField:
            product.price = text
        default: break
        }
    }
    
    @IBAction func updateButtonPressed(_ sender: Any) {
        showProgressHUD()
        
        FirebaseAPI.instance.updateProduct(product: product) { (error) in
            self.saveImage(image: self.productImage.image!, uid: self.product.uid) { (error) in
                self.hideProgressHUD()
                self.showAlert(title: "Update Completed", message: "You successfuly update your product!")
            }
        }
    }
}
extension EditProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.productImage.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
