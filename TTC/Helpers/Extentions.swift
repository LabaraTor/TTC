//
//  Extentions.swift
//  TTC
//
//  Created by Торнике Двалашвили on 16.05.18.
//  Copyright © 2018 Торнике Двалашвили. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func setProfileImage(profileImageUrl: String){
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: profileImageUrl as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        let url = URL(string: profileImageUrl)
        let request = URLRequest(url:url!)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil{
//                self.present(Lib.showError(error: error!), animated: true, completion: nil)
                return
            }
            
            DispatchQueue.main.async{
                if let image = UIImage(data: data!){
                    imageCache.setObject(image, forKey: profileImageUrl as AnyObject)
                    self.image = image
                }
            }
            }.resume()
    }
}
