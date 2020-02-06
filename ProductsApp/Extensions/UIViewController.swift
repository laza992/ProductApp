//
//  UIViewController.swift
//  ProductsApp
//
//  Created by developer on 21.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = nil, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAlertAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion?()
        }
        alert.addAction(okAlertAction)
        present(alert, animated: true)
    }
    
    func yesNoAction(title: String? = nil, message: String, leftButtonTitle: String = "No", rightButtonTitle: String = "Yes", yesCompletion: @escaping(() -> Void), noCompletion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let leftButtonAction = UIAlertAction(title: leftButtonTitle, style: .default) { (_) in
            noCompletion?()
        }
        let rightButtonAction = UIAlertAction(title: rightButtonTitle, style: .default) { (_) in
            yesCompletion()
        }
        alert.addAction(rightButtonAction)
        alert.addAction(leftButtonAction)
        present(alert, animated: true)
    }
    
    func showCameraPhotoLibraryAlert(title: String? = nil, message: String, camera: String = "Camera", photoLibrary: String = "Photo Library", cameraCompletion: @escaping(() -> Void), photoLibraryCompletion: @escaping(() -> Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cameraAlert = UIAlertAction(title: camera, style: .default) { (_) in
            cameraCompletion()
        }
        let photoLibraryAlert = UIAlertAction(title: photoLibrary, style: .default) { (_) in
            photoLibraryCompletion()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            
        }
        alert.addAction(cancel)
        alert.addAction(cameraAlert)
        alert.addAction(photoLibraryAlert)
        present(alert, animated: true)
    }
}
