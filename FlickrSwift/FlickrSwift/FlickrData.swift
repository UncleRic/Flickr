//
//  FlickrData.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 2/13/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

import Foundation
import UIKit

public struct PhotoStat: Codable {
    let page : Int
    let pages : Int
    let perpage : Int
    let total : String
}

public struct PhotoInfo: Codable {
    let id : String
    let owner : String
    let secret : String
    let server : String
    let farm : Int
    let title : String
    let ispublic : Int
    let isfriend :Int
    let isfamily : Int
    let url_t : String
    let height_t : String
    let width_t : String
    let url_s : String
    let height_s : String
    let width_s : String
    let url_m : String
    let height_m : String
    let width_m : String
    let url_sq : String
    let height_sq : Int
    let width_sq : Int
}

public struct PhotoStuff: Codable {
    let page: Int
    let pages: Int
    let perpage: Int
    let total:String
    let photo:[PhotoInfo]
}

public struct PhotoListModel: Codable {
    let photos:PhotoStuff
    let stat:String
}

// -----------------------------------------------------------------------------------------------------

struct ImageDownloadItem {
    var itemID = 0
    var image:UIImage?
    var bigImage:UIImage?
    var photoInfo:PhotoInfo?
    var descString:String?
    
    init (photoInfo: PhotoInfo) {
        self.photoInfo = photoInfo
    }
    
    func debugDescription() -> NSString {
        let myString = NSString(format:"{ImageDownloadItem} desc: %@", descString!)
        return myString
    }
}

// ===================================================================================================

extension MainViewController {
    
    private func cleanData(data: Data) -> Data? {
        var dataString:String = (NSString(data: data, encoding: String.Encoding.utf8.rawValue) as String?)!
        
        if !dataString.isEmpty {
            dataString.removeFirst(14)
            dataString.removeLast()
        }
        return dataString.data(using: .utf8)
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func disseminateJSON(data: Data) -> PhotoStuff? {
        var photos:PhotoStuff?
        do {
            if let cleanData = cleanData(data: data) {
                let flickrData = try JSONDecoder().decode(PhotoListModel.self, from: cleanData)
                photos = flickrData.photos
            }
            
        } catch let error as NSError {
            let title = "JSON Dissemination Error"
            let alert = UIAlertController(title: title, message: error.debugDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return photos
    }
    
    // -----------------------------------------------------------------------------------------------------
    
    func downloadImageAtURL(_ url:URL, completion:@escaping (_ image:UIImage?, _ error:NSError?) ->Void) {
        let task = URLSession.shared.dataTask(with: url, completionHandler: {(data, response, error) in
            if let httpRes = response as? HTTPURLResponse {
                if httpRes.statusCode == 200 {
                    let myImage = UIImage(data:data!)
                    DispatchQueue.main.async(execute: {
                        completion(myImage,nil)
                    })
                }
            }
        })
        task.resume()
    }
}
