//
//  UIImageView+Extension.swift
//  GithubQuery
//
//  Created by dkotha on 9/17/19.
//  Copyright © 2019 personal. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func downloadImage(from urlString: String, contentMode: UIView.ContentMode = .scaleAspectFit) {
        /// Set the image if it already exists in the cache
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.contentMode = contentMode
            self.image = cachedImage
            return
        }
    
        /// Download the image if not present in cache
        guard let url = URL(string: urlString) else { return }
        let downloadTask = URLSession(configuration: .default).downloadTask(with: url) { (locationUrl, response, error) in
            if let location = locationUrl {
                do {
                    let data = try Data(contentsOf: location)
                    guard let image = UIImage(data: data) else { return }
                    imageCache.setObject(image, forKey: urlString as NSString)
                    DispatchQueue.main.async {
                        self.contentMode = contentMode
                        self.image = image
                    }
                } catch {
                    print(error)
                }
                
            }
        }
        downloadTask.resume()
    }
}
