//
//  ImageController.swift
//  BucketList
//
//  Created by Alex Whitlock on 5/15/17.
//  Copyright © 2017 Alex Whitlock. All rights reserved.
//

import Foundation
import UIKit

class ImageController {
    
    static func image(forURL url: String, completion: @escaping (UIImage?) -> Void) {
        
        guard let url = URL(string: url) else {
            fatalError("Image URL optional is nil")
        }
        
        NetworkController.performRequest(for: url, httpMethod: .Get, urlParameters: nil, body: nil) { (data, error) in
            guard let data = data,
                let image = UIImage(data: data) else {
                    completion(nil)
                    return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }   
    }
}
