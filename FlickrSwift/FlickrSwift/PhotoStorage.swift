//
//  PhotoStorage.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 2/16/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

import Foundation
import Photos

extension DetailViewController {
    class func RequestLibraryAccess() {
        PHPhotoLibrary.requestAuthorization { (authorizationStatus) in
            switch (authorizationStatus) {
            case .authorized:
                print("Autorized")
                
            case .denied:
                print("Denied")
                
            case .notDetermined:
                print("Not Determined")
                
            case .restricted:
                print("Restricted")
                
            }
        }
    }
    
    // -----------------------------------------------------------------------------------------------------------------
    
    func savePhoto() {
        guard let myImage = self.imageView.image else {
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let changeRequest = PHAssetChangeRequest.creationRequestForAsset(from: myImage)
            changeRequest.creationDate = Date()
        }) { (success, error) in
            if success {
                self.statusLabel.isHidden = false;
            } else {
                print(error.debugDescription)
            }
        }
    }
}
