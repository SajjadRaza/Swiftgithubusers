//
//  UIImageViewExtension.swift
//  GitHubUsersSampleApp
//
//  Created by Sajjad Raza on 08/03/2021.
//

import Foundation
import UIKit

private var activityIndicatorAssociationKey: UInt8 = 0

let imageCache = NSCache<AnyObject, AnyObject>()

enum ImageSize {
    case original
    case thumbnail
}

extension UIImageView {
    func setImage(withImageURL imageurl: String, placeholderImage: UIImage? = nil, size: ImageSize = .original) {
        cacheImage(urlString: imageurl, placeholder: placeholderImage)
    }
    
    var activityIndicator: UIActivityIndicatorView! {
        get {
            return objc_getAssociatedObject(self, &activityIndicatorAssociationKey) as? UIActivityIndicatorView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &activityIndicatorAssociationKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func showActivityIndicator() {
        
        if self.activityIndicator == nil {
            self.activityIndicator = UIActivityIndicatorView(style: .medium)
            
            self.activityIndicator.hidesWhenStopped = true
            self.activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
            self.activityIndicator.style = .medium
            self.activityIndicator.center = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
            self.activityIndicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
            self.activityIndicator.isUserInteractionEnabled = false
            
            OperationQueue.main.addOperation({ () -> Void in
                self.addSubview(self.activityIndicator)
                self.activityIndicator.startAnimating()
            })
        }
    }
    
    func hideActivityIndicator() {
        OperationQueue.main.addOperation({ () -> Void in
            self.activityIndicator.stopAnimating()
        })
    }
    
    func cacheImage(urlString: String, placeholder: UIImage? = nil) {
        self.showActivityIndicator()
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.hideActivityIndicator()
            return
        }
        
        let urlwithPercent = urlString.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        let urlRequest = URLRequest(url: URL(string: urlwithPercent!)!)
        
        self.image = placeholder
        URLSession.shared.dataTask(with: urlRequest) {data, _, _ in
            if data != nil {
                DispatchQueue.main.async {
                    let imageToCache = UIImage(data: data!)
                    if imageToCache != nil {
                        imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                        self.image = imageToCache
                    }
                    self.hideActivityIndicator()
                }
            }
        }.resume()
    }
}
