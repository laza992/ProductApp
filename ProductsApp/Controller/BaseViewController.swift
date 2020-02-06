//
//  BaseViewController.swift
//  ProductsApp
//
//  Created by developer on 19.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    
    private var indicatorView: NVActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setupIndicatorView(frame: view.frame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func setupIndicatorView(frame: CGRect) {
        let indicatorSize: CGFloat = 100
        let midPoint = CGPoint(x: frame.midX - indicatorSize / 2, y: frame.midY - indicatorSize / 2)
        let viewSize = CGSize(width: indicatorSize, height: indicatorSize)
        
        indicatorView = NVActivityIndicatorView(frame: CGRect(origin: midPoint, size: viewSize))
        
        indicatorView?.type = .ballClipRotate
        indicatorView?.color = .white
        
        view.addSubview(indicatorView!)
    }
    
    func showProgressHUD() {
        indicatorView?.startAnimating()
        userIteraction(enabled: false)
    }
    
    func hideProgressHUD() {
        indicatorView?.stopAnimating()
        userIteraction(enabled: true)
    }
    
    private func userIteraction(enabled: Bool) {
        if let unwrappedNavigationBarController = navigationController {
            unwrappedNavigationBarController.view.isUserInteractionEnabled = enabled
        } else {
            view.isUserInteractionEnabled = enabled
        }
    }
}
