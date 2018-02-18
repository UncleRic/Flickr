//  SimpleFlickrAPI.m
//  Session
//
//  Created by Frederick C. Lee on 9/13/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// ------------------------------------------------------------------------------------

#import "SimpleFlickrAPI.h"
#import <Foundation/NSJSONSerialization.h>                              // 1

NSString const *flickrAPIKey = @"ebbefd0c0a07c996f7867f014778adf7";
NSString const *flickrAPISecret = @"bf823c361bc6f09e";
NSString const *sharkAPIKey = @"949e98778755d1982f537d56236bbb42";

// Changes this value to your own application key. More info
// at http://www.flickr.com/services/api/misc.api_keys.html.
// #define flickrAPIKey @"YOUR_FLICKR_APP_KEY"                             // 2

// ------------------------------------------------------------------------------------
// Each RESTful API uses the same base URL.
// The base URL is stored as a macro, making it easy to change should Flickr ever change the URL.
// Also note the query string parameter format.
// It is set to JSON, which tells the Flickr API to return data formatted with JSON.

#define flickrBaseURL \
@"https://api.flickr.com/services/rest/?format=json&"                    // 3


// @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=949e98778755d1982f537d56236bbb42&text=shark&format=json&nojsoncallback=1&page=1"

// ------------------------------------------------------------------------------------
// The Flickr API uses different parameter names.
// Instead of the Flickr API parameter names being hard-coded throughout, they are defined here as macros.
// The Flickr API parameters are defined as query string parameters on the HTTP GET request.

#define flickrParamMethod @"method"                                     // 4
#define flickrParamAppKey @"api_key"
#define flickrParamUsername @"username"
#define flickrParamUserid @"user_id"
#define flickrParamPhotoSetId @"photoset_id"
#define flickrParamExtras @"extras"
#define flickrParamText @"text"
#define flickrParamTag @"tags"
#define flickrParamTagMode @"tag_mode"

// ------------------------------------------------------------------------------------
//The Flickr API includes a parameter named method.
// This parameter defines which API method is called.
// The API methods supported by this simple wrapper are defined here as macros.

#define flickrMethodFindByUsername @"flickr.people.findByUsername"      // 5
#define flickrMethodGetPhotoSetList @"flickr.photosets.getList"
#define flickrMethodGetPhotosWithPhotoSetId @"flickr.photosets.getPhotos"
#define flickrMethodSearchPhotos @"flickr.photos.search"

// =======================================================================================================================

@implementation SimpleFlickrAPI


- (NSURL *)getURLForString:(NSString *)str tags:(NSString *)tags {
    
    NSDictionary *parameters = @{
                                 flickrParamMethod : flickrMethodSearchPhotos,
                                 flickrParamAppKey : sharkAPIKey,
                                 flickrParamText : str,
                                 flickrParamTag : tags,
                                 flickrParamTagMode : @"all",
                                 flickrParamExtras : @"url_t, url_s, url_m, url_sq",
                                 };
    
    NSURL *URL = [self buildFlickrURLWithParameters:parameters];
    
    return URL;
}


// -----------------------------------------------------------------------------------------------------------------------
// (22) The method -buildFlickrURLWithParameters: takes the dictionary of parameters and creates the URL to the API call.
// This is done by appending each key-value pair in the dictionary as a query string parameter to the base Flickr API URL.

- (NSURL *)buildFlickrURLWithParameters:(NSDictionary *)parameters {     // 22

    NSMutableString *URLString = [[NSMutableString alloc]
                                  initWithString:flickrBaseURL];
    for (id key in parameters) {
        NSString *value = [parameters objectForKey:key];
        [URLString appendFormat:@"%@=%@&", key,
         [value stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    }
    NSURL *url = [NSURL URLWithString:URLString];
    return url;
}

// -----------------------------------------------------------------------------------------------------------------------
// The method -stringWithData: converts the contents of an NSData object to a string.
// As you will see momentarily, the response data from Flickr requires a bit of tweaking before NSJSONSerialization can parse it.

- (NSString *)stringWithData:(NSData *)data   {

    NSString *result = [[NSString alloc] initWithBytes:[data bytes]
                                                length:[data length]
                                              encoding:NSUTF8StringEncoding];
    return result;
}

// -----------------------------------------------------------------------------------------------------------------------
// The method -stringByRemovingFlickrJavaScript: returns a cleaned-up version of the Flickr API response data.
// The Flickr API wraps the response data in a JavaScript function, but the SimpleFlickrAPI wants only the JSON data.
// Consequently, the response data is converted from an NSData object to an NSString object.
// The JavaScript function is then stripped from the string, resulting in the string containing only the JSON-formatted data.

- (NSString *)stringByRemovingFlickrJavaScript:(NSData *)data    {

    // Flickr returns a JavaScript function containing the JSON data.
    // We need to strip out the JavaScript part before we can parse
    // the JSON data. Ex: jsonFlickrApi(JSON-DATA-HERE).
    
    NSMutableString *string = [[self stringWithData:data] mutableCopy];
    NSRange range = NSMakeRange(0, [@"jsonFlickrApi(" length]);
    [string deleteCharactersInRange:range];
    range = NSMakeRange([string length] - 1, 1);
    [string deleteCharactersInRange:range];
    
    return string;
}


@end
