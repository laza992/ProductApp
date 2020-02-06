//
//  UIImageView.swift
//  ProductsApp
//
//  Created by developer on 14.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func setImage(url: URL?, defaultImage: UIImage? = nil) {
        
        self.kf.indicatorType = .activity
        
        if let unwURL = url {
            self.kf.setImage(
                with: unwURL,
                options: [],
                completionHandler: { [weak self] (image, _, _, _) in
                    if let unwImage = image {
                        self?.image = unwImage
                    } else {
                        self?.image = defaultImage
                    }
            })
        } else {
            self.image = defaultImage
        }
    }
}
