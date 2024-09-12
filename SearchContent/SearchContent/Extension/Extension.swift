//
//  Extension.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func loadImage(urlString: String) {
        self.image = UIImage(systemName: "photo")
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "questionmark.app")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let downloadedImage = UIImage(data: data) {
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            } else {
                DispatchQueue.main.async {
                    self?.image = UIImage(systemName: "questionmark.app")
                }
            }
        }.resume()
    }
}
