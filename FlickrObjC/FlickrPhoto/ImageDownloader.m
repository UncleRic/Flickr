//  ImageDownloader.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/15/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import "ImageDownloader.h"

@interface ImageDownloader ()
@property (nonatomic, strong) NSMutableData *receivedData;

// (1) The declared property completion stores a reference to the code block provided by the caller.
//This block is called once the download has completed.

@property (nonatomic, copy) ImageDownloaderCompletionBlock completion;  // 1
@end

@implementation ImageDownloader

#pragma mark Singleton functions

- (NSString *)debugDescription {
    return [NSString stringWithFormat:@"{ImageDownloader} \nbigImage: %@\ndict: %@", _bigImage, _dict];
}

// -----------------------------------------------------------------------------------------------------------------------

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.dict = dict;
    }
    return self;
}

// -----------------------------------------------------------------------------------------------------------------------
- (void)downloadImageAtURL:(NSURL *)URL
                completion:(void(^)(UIImage *image, NSError *error))completion {
    if (URL) {
        [[[NSURLSession sharedSession] dataTaskWithURL:URL
                                     completionHandler:^(NSData *data,
                                                         NSURLResponse *response,
                                                         NSError *error) {
                                         if (!error) {
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 UIImage *image = [UIImage imageWithData:(NSData *)data];
                                                 completion(image, nil);
                                             });
                                         } else {
                                             completion(nil, error);
                                             NSLog(@"--- {ImageDownLoader} Error: %@ ---",error);
                                         }
                                     }] resume];
        
    }
    
}




@end
