//
//  DetailViewController.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/16/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
//

#import "DetailViewController.h"
#import "ImageDownloader.h"
#import "MainViewController.h"
#import "DetailViewController+PhotoAssets.h"

@interface DetailViewController ()
@property (weak, nonatomic) MainViewController *mainViewController;
@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [DetailViewController RequestLibraryAccess];
}

// -----------------------------------------------------------------------------------------------------------------

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSString *title = _currentImageDownloader.dict[@"title"];
    
    if (title.length == 0) {
        self.title = @"No Title";
    } else {
        self.title = title;
    }
    [self displayBigImage];
}

- (void)viewDidDisappear:(BOOL)animated {
    self.statusLabel.hidden = true;
}

- (void)displayAlert {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry, Not Available"
                                                                   message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// -----------------------------------------------------------------------------------------------------------------
#pragma mark - Action methods

- (IBAction)downloadAction:(UIButton *)sender {
    [self savePhoto];
}

// -----------------------------------------------------------------------------------------------------------------

- (IBAction)openInAppAction:(UIButton *)sender {
    [self displayAlert];
}

// -----------------------------------------------------------------------------------------------------------------------

- (void)displayBigImage {
    ImageDownloaderCompletionBlock completion = ^(UIImage *image, NSError *error) {
        if (image) {
            self.imageView.image = image;
        } else {
            NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__,
                  [error localizedDescription]);
        }
    };
    
    UIImage *image = [_currentImageDownloader bigImage];
    
    if (image) {
        self.imageView.image = image;
    } else {
        NSURL *URL = [NSURL URLWithString:_currentImageDownloader.dict[@"url_m"]];
        [_currentImageDownloader downloadImageAtURL:URL completion:completion];
    }
}

@end
