//
//  PhotoCollectionView.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 2/10/18.
//  Copyright © 2018 Frederick C. Lee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoCollectionView.h"

@implementation PhotoCollectionView

- (void)recenterIfNecessary {
    CGPoint currentOffset = self.contentOffset;
    CGFloat contentWidth = self.contentSize.width;
    CGFloat centerOffsetX = (contentWidth - self.bounds.size.width) / 2.0;
    CGFloat distanceFromCenter = fabs(currentOffset.x - centerOffsetX);
    
    if (contentWidth > 0 && (distanceFromCenter > (contentWidth / 2.5))) {
        self.contentOffset = CGPointMake(centerOffsetX, currentOffset.y);
        // Move content by the same amount so it appears to stay still.
        // Note: Need to determine correct algorithm.
        //       Ran out-of-time on this one.
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self recenterIfNecessary];
}

@end

