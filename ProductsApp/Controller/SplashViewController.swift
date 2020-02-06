//
//  SplashViewController.swift
//  ProductsApp
//
//  Created by developer on 12.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import RevealingSplashView
import Firebase
import FirebaseAuth

class SplashViewController: UIViewController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "logo")!,iconInitialSize: CGSize(width: 250, height: 250), backgroundColor: .clear)
        revealingSplashView.animationType = SplashAnimationType.squeezeAndZoomOut
        
        //Adds the revealing splash view as a sub view
        self.view.addSubview(revealingSplashView)
        
        //Starts animation
        revealringSplashView.startAnimation() {
            
            if Auth.auth().currentUser == nil {
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
                guard let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "loginViewController") as? LoginViewController else { return }
                UIApplication.shared.windows.filter({ $0.isKeyWindow }).first?.rootViewController = loginViewController
            } else {
                let initialTabVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MainTab")
                let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first!
                window.makeKeyAndVisible()
                window.rootViewController = initialTabVC
            }
        }
    }
}

