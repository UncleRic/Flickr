//  SimpleFlickrAPI.h
//  Session
//
//  Created by Frederick C. Lee on 9/13/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

@interface SimpleFlickrAPI : NSObject

- (NSString *)stringByRemovingFlickrJavaScript:(NSData *)data;
- (NSURL *)getURLForString:(NSString *)str tags:(NSString *)tags;

@end
