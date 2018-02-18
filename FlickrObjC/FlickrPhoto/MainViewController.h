//  MainViewController.h
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/14/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import <UIKit/UIKit.h>

@class ImageDownloader;

@interface MainViewController : UIViewController 
@property (nonatomic, strong) ImageDownloader *currentImageDownloader;
@property NSInteger selectedItemIndex;
@end

