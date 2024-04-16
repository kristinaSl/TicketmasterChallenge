//
//  UIImageView+Download.swift
//  TicketMasterChallenge
//
//  Created by Kristina Borisova on 14/04/2024.
//

import UIKit

extension UIImageView {
    
    struct Holder {
        static var dataTask: URLSessionDataTask?
    }
    
    var computedDataTask: URLSessionDataTask? {
        get {
            return Holder.dataTask
        }
        set(newValue) {
            Holder.dataTask = newValue
        }
    }
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = placeHolder
        if let cachedImage = ImageStorage().retrieveImageFromCoreData(urlString: URLString) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            self.computedDataTask = URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, response, error) in
                guard let `self` = self else { return }
                if error != nil {
                    print("Can't download image from URL: \(String(describing: error))")
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            ImageStorage().saveImageToCoreData(image: downloadedImage, urlString: URLString)
                            self.image = downloadedImage
                        }
                    }
                }
            })
            self.computedDataTask?.resume()
        }
    }
    
    func cancelImageDownload() {
        self.computedDataTask?.cancel()
    }
}

