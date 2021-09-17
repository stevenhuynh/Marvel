//
//  ThumbnailService.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import UIKit

class ThumbnailService {
    static let shared = ThumbnailService()
    private let cache = NSCache<AnyObject, AnyObject>()
    private let session = URLSession(configuration: .default)
    
    private init() {}
    
    func downloadThumbnail(_ url: URL, completion: @escaping (UIImage?) -> Void) {
        if let cachedThumbnail = cache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            completion(cachedThumbnail)
            return
        }
        
       session.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            DispatchQueue.main.async {
                if let image = UIImage(data: data) {
                    self.cache.setObject(image, forKey: url.absoluteString as AnyObject)
                    completion(image)
                    return
                }
                completion(nil)
            }
        }.resume()
    }
}

