//
//  FirebaseAPI.swift
//  ProductsApp
//
//  Created by developer on 12.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class FirebaseAPI {
    
    // References
    
    static let instance = FirebaseAPI()
    static let databaseRef = Database.database().reference()
    static let storageRef = Storage.storage().reference()
    
    enum Endpoint {
        static let users = databaseRef.child("users")
        static let userImage = storageRef.child("userImage")
        
        static let meals = databaseRef.child("meals")
        static let mealImage = storageRef.child("mealImage")
    }
    
    // Functions
    
    func createDBUser(uid: String, userData: [String: Any]) {
        FirebaseAPI.Endpoint.users.child(uid).updateChildValues(userData)
    }
    
    func uploadProfilePhoto(uid: String, image: UIImage, completionHandler: @escaping (Error?) -> ()) {
        let userStorageRef = FirebaseAPI.storageRef.child("user\(uid)")
        let metaData = StorageMetadata()
        metaData.contentType = "img/jpg"
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            userStorageRef.putData(data, metadata: metaData) { (_, error)
                in
                if let error = error {
                    completionHandler(error)
                } else {
                    userStorageRef.downloadURL { (url, error) in
                        if let url = url {
                            FirebaseAPI.Endpoint.users.child(uid).updateChildValues(["profileImage": url.absoluteString], withCompletionBlock: { (error, _) in
                                completionHandler(error)
                            })
                        } else {
                            completionHandler(error)
                        }
                    }
                }
            }
        }
    }
    
    func registerUser(fullName: String, withEmail email: String, password: String, dateOfBirth: String, image: UIImage, userCreationComplete: @escaping (Error?) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let user = authResult?.user else {
                userCreationComplete(error)
                return
            }
            let userData = ["provider": user.providerID, "email": user.email, "fullName": fullName]
            FirebaseAPI.instance.createDBUser(uid: user.uid, userData: userData)
            userCreationComplete(nil)
        }
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ error: Error?) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            loginComplete(error)
        }
    }
    
    func updateUserInfo(uid: String, parameters: [String: Any], completion: @escaping(Error?) -> Void) {
        Endpoint.users.child(uid).updateChildValues(parameters) { (error, _) in
            completion(error)
        }
    }
    
    func uploadPost(withMealName name: String, andPrice price: String, picture: UIImage, completion: @escaping (Error?) -> ()) {
        
        let userStorageRef = FirebaseAPI.storageRef.child("meals\(UUID().uuidString)")
        let metaData = StorageMetadata()
        metaData.contentType = "img/jpg"
        
        if let data = picture.jpegData(compressionQuality: 0.9) {
            userStorageRef.putData(data, metadata: metaData) { (_, error)
                in
                if let error = error {
                    completion(error)
                } else {
                    userStorageRef.downloadURL { (url, error) in
                        if let url = url {
                            let params: [String: Any] = ["name": name, "price": price, "date": Date().timeIntervalSince1970, "uid": Auth.auth().currentUser?.uid ?? "", "mealImage": url.absoluteString]
                            
                            let autoUID = FirebaseAPI.Endpoint.meals.childByAutoId().key!
                            Endpoint.meals.child(autoUID).updateChildValues(params) { (error, _) in
                                completion(error)
                            }
                        } else {
                            completion(error)
                        }
                    }
                }
            }
        }
    }
    
    func uploadMealPhoto(uid: String, image: UIImage, completionHandler: @escaping (Error?) -> ()) {
        let userStorageRef = FirebaseAPI.storageRef.child("meals\(uid)")
        let metaData = StorageMetadata()
        metaData.contentType = "img/jpg"
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            userStorageRef.putData(data, metadata: metaData) { (_, error)
                in
                if let error = error {
                    completionHandler(error)
                } else {
                    userStorageRef.downloadURL { (url, error) in
                        if let url = url {
                            FirebaseAPI.Endpoint.meals.child(uid).updateChildValues(["mealImage": url.absoluteString], withCompletionBlock: { (error, _) in
                                completionHandler(error)
                            })
                        } else {
                            completionHandler(error)
                        }
                    }
                }
            }
        }
    }
    
    func getAllProducts(handler: @escaping (_ Products: [Products]) -> ()) {
        var productsArray = [Products]()
        
        FirebaseAPI.Endpoint.meals.observe(.value) { (productsSnapshot) in
            guard let productsSnapshot = productsSnapshot.children.allObjects as? [DataSnapshot] else {
                return
            }
            for products in productsSnapshot {
                let name = products.childSnapshot(forPath: "name").value as! String
                let price = products.childSnapshot(forPath: "price").value as! String
                let mealImage = products.childSnapshot(forPath: "mealImage").value as! String // TODO Fix
                let dateInterval = products.childSnapshot(forPath: "date").value as! TimeInterval
                let date = Date(timeIntervalSince1970: dateInterval)
                let userUid = products.childSnapshot(forPath: "uid").value as! String
                let uid = products.key
                let products = Products(name: name, price: price, mealImage: mealImage, date: date, uid: uid, userUid: userUid)
                
                productsArray.append(products)
            }
            
            handler(productsArray)
        }
    }
    
    func getUser(uid: String, handler: @escaping (_ userModel: UserModel) -> ()) {
        FirebaseAPI.Endpoint.users.child(uid).observe(.value) { (userSnapshot) in
            guard let userDict = userSnapshot.value as? [String: Any] else { return }
            
            let fullName = userDict["fullName"] as! String
            let email = userDict["email"]as! String
            let imageURL = userDict["profileImage"] as! String
            let dateOfBirth = Date().timeIntervalSince1970
            let user = UserModel(fullName: fullName, email: email, imageURL: imageURL, dateOfBirth: dateOfBirth, uid: userSnapshot.key)
            
            handler(user)
        }
    }
    
    func updateProduct(product: Products, completionHandler: @escaping (Error?) -> ()) {
        let price = product.price.replacingOccurrences(of: "$", with: "")
        FirebaseAPI.databaseRef.child("meals").child(product.uid).updateChildValues(["name": product.name, "price": price, "mealImage": product.imageURLString]) { (error, _) in
            if let error = error {
                debugPrint(error)
            } else {
                completionHandler(nil)
            }
        }
    }
    
    func updateProfile(user: UserModel, image: UIImage, completionHandler: @escaping (Error?) -> ()) {
        
        let userStorageRef = FirebaseAPI.storageRef.child("user\(user.uid)")
        let metaData = StorageMetadata()
        metaData.contentType = "img/jpg"
        
        if let data = image.jpegData(compressionQuality: 0.9) {
            userStorageRef.putData(data, metadata: metaData) { (_, error)
                in
                if let error = error {
                    completionHandler(error)
                } else {
                    userStorageRef.downloadURL { (url, error) in
                        if let url = url {
                            Endpoint.users.child(user.uid).updateChildValues(["fullName": user.fullName, "email": user.email, "profileImage": url.absoluteString]) { (error, _) in
                                if let error = error {
                                    debugPrint(error.localizedDescription)
                                } else {
                                    completionHandler(nil)
                                }
                            }
                        } else {
                            completionHandler(error)
                        }
                    }
                }
            }
        }
    }
    
    func deleteProduct(_ productID: String, completion: @escaping(Error?) -> Void) {
        Endpoint.meals.child(productID).removeValue { (error, _) in
            completion(error)
        }
    }
}
