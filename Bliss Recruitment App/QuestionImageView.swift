//
//  QuestionImageView.swift
//  Bliss Recruitment App
//
//  Created by Luís Machado on 26/05/17.
//  Copyright © 2017 LuisMachado. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

class QuestionImageView: UIImageView {
    
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String, completion: (() -> ())?) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: NSString(string: urlString)) {
            self.image = imageFromCache
            if let completion = completion {
                completion()
            }
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if let error = error {
                print(error)
            }
            
            if let data = data {
                DispatchQueue.main.async(execute: {
                    
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: urlString))
                        
                        if self.imageUrlString == urlString {
                            self.image = downloadedImage
                            
                            if let completion = completion {
                                completion()
                            }
                        }
                    }
                })
            }
            
        }).resume()
    }
    
}
