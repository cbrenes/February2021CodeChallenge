//
//  CustomImageViewWithCache.swift
//  CodeChallenge
//
//  Created by Cesar Brenes on 19/2/21.
//

import Foundation
import UIKit

class CustomImageViewWithCache: UIImageView {
    
    let imageCache = NSCache<NSString, AnyObject>()
    var activityIndicator = UIActivityIndicatorView()
    
    var httpClient = HTTPClientWorker(session: URLSession.shared)
    var dataTask: URLSessionDataTaskProtocol? = nil
    
    /**
     Downloads an image stored in the cloud using an URL, this method works using URLSessionDataTask to allow the hability to cancell operations when they already started, this is very helpful in the case the class is used in a table view and we need to cancel the operation of the cell that are hidden
     In the case the download fails for some reason the method shows an error image
     This method handles an activity indicator while the download is in progress

     - Parameter url: The url of the image we want to download
     - Parameter imageMode: If this parameter is not provided, .scaleAspectFit will be used by default
     - Parameter imageNotFound: The image will be used in the case the url returns an error trying to download the image, ImageHelper.imageNotFound.rawValue will be used by default

     */
    func downloadImage(url: URL?, imageMode: UIView.ContentMode = .scaleAspectFit, imageNotFound: String = ImageHelper.imageNotFound.rawValue) {
        guard let url = url else { return }
        downloadImage(url: url, imageMode: imageMode, imageNotFound: UIImage(named: imageNotFound), completionHandler: nil)
    }
    
    func downloadImage(url: URL, imageMode: UIView.ContentMode, imageNotFound: UIImage?, completionHandler:(() -> Void)?) {
        setupActivityIndicator()
        contentMode = imageMode
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            setImage(image: cachedImage, urlString: url.absoluteString, completionHandler: completionHandler)
        } else {
            DispatchQueueHelper.executeInMainThread { [weak self] in
                self?.image = nil
                self?.activityIndicator.startAnimating()
            }
            dataTask?.cancel()
            dataTask = httpClient.dataTask(with: url) {[weak self] (data, response, error) in
                self?.handleURLResponse(url: url, data: data, response: response, error: error, imageNotFound: imageNotFound, completionHandler: completionHandler)
            }
            dataTask?.resume()
        }
    }
    
    private func handleURLResponse(url: URL, data: Data?, response: URLResponse?, error: Error?, imageNotFound: UIImage?, completionHandler:(() -> Void)?) {
        if let error = error, (error as NSError?)?.code != NSURLErrorCancelled {
            setImage(image: imageNotFound, urlString: nil, completionHandler: completionHandler)
            return
        }
        if let data = data, let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: url.absoluteString as NSString)
            setImage(image: image, urlString: url.absoluteString, completionHandler: completionHandler)
        } 
    }
    
    private func setupActivityIndicator() {
        if !activityIndicator.isDescendant(of: self) {
            activityIndicator.color = .darkGray
            addSubview(activityIndicator)
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    private func setImage(image: UIImage?, urlString: String?, completionHandler:(() -> Void)?) {
        DispatchQueueHelper.executeInMainThread { [weak self] in
            self?.image = image
            self?.image?.accessibilityIdentifier = urlString
            self?.activityIndicator.stopAnimating()
            completionHandler?()
        }
    }
}
