//  DetailViewController.h
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/16/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------
#import <UIKit/UIKit.h>
#import "ImageDownloader.h"

@interface DetailViewController : UIViewController
@property (nonatomic, strong) ImageDownloader *currentImageDownloader;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
