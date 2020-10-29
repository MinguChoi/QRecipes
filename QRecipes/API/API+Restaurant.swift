//
//  API+Restaurant.swift
//  QRecipes
//
//  Created by Mingu Choi on 10/16/20.
//  Copyright © 2020 Kyo. All rights reserved.
//

import Firebase

struct newRestaurant {
    let name: String
    let address: String
    let phone: String
    var recipes: [String]
    var restaurantImage: UIImage
}

extension API {
    
    static func uploadRestaurant(restaurant: newRestaurant, completion: @escaping(Error?, DatabaseReference?) -> Void ) {
        guard let imageData = restaurant.restaurantImage.jpegData(compressionQuality: 0.3) else { return }

        let filename = NSUUID().uuidString
        let storageRef = ST_RESTAURANT_IMAGE.child(filename)
        storageRef.putData(imageData, metadata: nil) { (meta, error) in
            storageRef.downloadURL { (url, error) in
                guard let restaurantImageUrl = url?.absoluteString else {
                    return
                }
                let values = ["name": restaurant.name,
                              "address": restaurant.address,
                              "phone": restaurant.phone,
                              "recipes": restaurant.recipes,
                              "restaurantImageUrl": restaurantImageUrl] as [String : AnyObject]
                
                DB_RESTAURANT.childByAutoId().setValue(values, withCompletionBlock: completion)
           }
        }
    }
    
    

}
    
