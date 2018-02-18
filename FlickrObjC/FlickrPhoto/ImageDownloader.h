//  ImageDownloader.h
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/15/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// (1) The ImageDownloader class stores a completion block that is called once the image has been downloaded.
// To make the code more readable, the ImageDownloaderCompletionBlock typedef is defined.
// This approach means that you do not have to redeclare the block definition everywhere it is used.

typedef void(^ImageDownloaderCompletionBlock)(UIImage *image, NSError *error);   // 1


@interface ImageDownloader : NSObject

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) UIImage *image, *bigImage;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (void)downloadImageAtURL:(NSURL *)URL
                completion:(void(^)(UIImage *image, NSError *error))completion;

@end
