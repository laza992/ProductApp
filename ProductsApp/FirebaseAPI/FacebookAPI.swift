//
//  FacebookAPI.swift
//  ProductsApp
//
//  Created by developer on 21.11.19.
//  Copyright © 2019 developer. All rights reserved.
//

import Foundation
import FBSDKCoreKit

class FacebookAPI {
    
    static func getFacebookUserData(completion: @escaping(String?, String?, Error?) -> Void) {
        
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id,name , first_name, last_name , email,picture.type(large)"]).start(completionHandler: { (connection, result, error) in
                
                guard let info = result as? [String: Any] else {
                    completion(nil, nil, nil)
                    return
                }
                
                let fullName = info["name"] as? String
                let imageURL = ((info["picture"] as? [String: Any])?["data"] as? [String: Any])?["url"] as? String
                
                completion(fullName, imageURL, error)
            })
        }
    }
}
