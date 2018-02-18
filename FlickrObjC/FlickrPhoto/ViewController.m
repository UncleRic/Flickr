//  ViewController.m
//  FlickrPhoto
//
//  Created by Frederick C. Lee on 9/14/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------------------------

#import "ViewController.h"
#import "SimpleFlickrAPI.h"
#import "ImageDownloader.h"

@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *downloaders;
@property (nonatomic, strong) NSArray *photoInfos;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchFlickrPhotoWithSearchString:@"Ric"];
}

// -----------------------------------------------------------------------------------------------------------------------

- (void)fetchFlickrPhotoWithSearchString:(NSString *)searchString {
    
    SimpleFlickrAPI *flickr = [SimpleFlickrAPI new];
    
    
    [[[NSURLSession sharedSession] dataTaskWithURL:[flickr getURLForString:@"Ric"]
                                 completionHandler:^(NSData *data,
                                                     NSURLResponse *response,
                                                     NSError *error) {
                                     if (!error) {
                                         NSString *string = [flickr stringByRemovingFlickrJavaScript:data];
                                         NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
                                         NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                    error:&error];
                                         
                                         self.photoInfos = [[jsonDict objectForKey:@"photos"] objectForKey:@"photo"];
                                         
                                         NSMutableArray *downloaders = [[NSMutableArray alloc] initWithCapacity:[_photoInfos count]];
                                         for (NSInteger index = 0; index < [_photoInfos count]; index++) {
                                             ImageDownloader *downloader = [ImageDownloader new];
                                             [downloaders addObject:downloader];
                                         }
                                         self.downloaders = downloaders; // ...link local array with instance array 'downloaders' (Note: same object!).
       
                                         dispatch_async(dispatch_get_main_queue(), ^{
                                             [self.collectionView reloadData];
                                         });
                                     } else {
                                         NSLog(@"*** {SessionDataError}: %@",error);
                                         // ...Handle Error.
                                     }
                                 }] resume];
    
 }

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDelegate methods
// ...to be implemented later.

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoInfos count];
}

// -----------------------------------------------------------------------------------------------------------------------

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:1];
    
    // •(1) Each cell displays an image of the photo from Flickr.
    //    However, the image must be downloaded first.
    //    The completion block for the ImageDownloader object is defined.
    //    The completion block sets the image property for cell’s photoImageView to the image passed in to the block.•
    //    ImageDownloader(completion) --> ViewController(completion)
    
    ImageDownloaderCompletionBlock completion =
    ^(UIImage *image, NSError *error) {                                  // 1
        if (image) {
            photoImageView.image = image;
        } else {
            NSLog(@"%s: Error: %@", __PRETTY_FUNCTION__,
                  [error localizedDescription]);
        }
    };
    
    NSInteger index = [indexPath item];   // ...NSIndexPath (UICollectionViewAdditions)
    
    NSArray *downloaders = [self downloaders];
    ImageDownloader *downloader = [downloaders objectAtIndex:[indexPath item]];
    
    // (2) If the image was previously downloaded, the cell’s image is set right away.
    // There is no reason to download it again.
    
    UIImage *image = [downloader image];                                 // 2
    
    if (image) {
        photoImageView.image = image;
    } else {
        NSURL *URL = [NSURL URLWithString:[[_photoInfos objectAtIndex:index] objectForKey:@"url_sq"]];
        [downloader downloadImageAtURL:URL completion:completion];
    }
    
    return cell;
}

// -----------------------------------------------------------------------------------------------------------------------
#pragma mark - Action methods

- (IBAction)doSomethingAction:(id)sender {
    return;
}

- (IBAction)exitAction:(id)sender {
    exit(0);
}

@end
