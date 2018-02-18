//
//  DetailViewController+PhotoAssets.h
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/11/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import "DetailViewController.h"
#import <Photos/PHPhotoLibrary.h>
#import <Photos/PHAssetResource.h>
#import <Photos/PHAssetChangeRequest.h>
#import <Photos/PHAssetCollectionChangeRequest.h>
#import <Photos/PHCollection.h>

@interface DetailViewController (PhotoAssets)
//@property (nonatomic, strong) PHAsset *photoAsset;
+ (void)RequestLibraryAccess;
- (void)savePhoto;

@end
