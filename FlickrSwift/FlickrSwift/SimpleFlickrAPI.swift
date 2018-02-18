//  SimpleFlickrAPI.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 9/22/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------

import Foundation

let flickrAPIKey = "ebbefd0c0a07c996f7867f014778adf7"
let flickrAPISecret = "bf823c361bc6f09e"

// Changes this value to your own application key. More info
// at http://www.flickr.com/services/api/misc.api_keys.html.
// let flickrAPIKey = "YOUR_FLICKR_APP_KEY"                             // 2

// ------------------------------------------------------------------------------------
// Each RESTful API uses the same base URL.
// The base URL is stored as a macro, making it easy to change should Flickr ever change the URL.
// Also note the query string parameter format.
// It is set to JSON, which tells the Flickr API to return data formatted with JSON.

let flickrBaseURL = "https://api.flickr.com/services/rest/?format=json&"

// ------------------------------------------------------------------------------------
// The Flickr API uses different parameter names.
// Instead of the Flickr API parameter names being hard-coded throughout, they are letd here as macros.
// The Flickr API parameters are letd as query string parameters on the HTTP GET request.


let flickrParamMethod = "method"                                     // 4
let flickrParamAppKey = "api_key"
let flickrParamUsername = "username"
let flickrParamUserid = "user_id"
let flickrParamPhotoSetId = "photoset_id"
let flickrParamExtras = "extras"
let flickrParamText = "text"
// ------------------------------------------------------------------------------------
//The Flickr API includes a parameter named method.
// This parameter lets which API method is called.
// The API methods supported by this simple wrapper are letd here as macros.

let flickrMethodFindByUsername = "flickr.people.findByUsername"      // 5
let flickrMethodGetPhotoSetList = "flickr.photosets.getList"
let flickrMethodGetPhotosWithPhotoSetId = "flickr.photosets.getPhotos"
let flickrMethodSearchPhotos = "flickr.photos.search"


// =======================================================================================================================


func getURLForString(str:String) -> NSURL {
    
    let parameters = [flickrParamMethod : flickrMethodSearchPhotos,
        flickrParamAppKey : flickrAPIKey,
        flickrParamText : str,
        flickrParamExtras : "url_t, url_s, url_m, url_sq"]
    
    var url = buildFlickrURLWithParameters(parameters)
    
    return url;
}  // ...end getURLForString

// -----------------------------------------------------------------------------------------------------

func buildFlickrURLWithParameters(parameters:Dictionary<String,String>) -> NSURL {
    var urlString = flickrBaseURL
    
    for key in parameters.keys {
        let value = parameters[key]?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        urlString += key+"="+value!+"&"
    }
    
    return NSURL.URLWithString(urlString)
}

// -----------------------------------------------------------------------------------------------------

func photosWithSearchString(str:String) -> Array<String> {
    let parameters = [flickrParamMethod : flickrMethodSearchPhotos,
                      flickrParamAppKey : flickrAPIKey,
                        flickrParamText : str,
                      flickrParamExtras : "url_t, url_s, url_m, url_sq"]
    
    let json:NSDictionary = flickrJSONSWithParameters(parameters)
    
    let myArray = [String]()
    return myArray
}

// -----------------------------------------------------------------------------------------------------

func flickrJSONSWithParameters(parameters:Dictionary<String,String>) -> NSDictionary {
    let url:NSURL = buildFlickrURLWithParameters(parameters)
 
    let data:NSData = fetchResponseWithURL(url)
    let string:NSString = stringByRemovingFlickrJavaScript(data)
    let jasonData:NSData? = string.dataUsingEncoding(NSUTF8StringEncoding)
    var error:NSError?
    
    let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as [NSDictionary:AnyObject]
    
   return json
    
}

// -----------------------------------------------------------------------------------------------------

func stringByRemovingFlickrJavaScript(data:NSData) -> NSString {

    var string = NSMutableString(data:data, encoding:NSUTF8StringEncoding)
    let len = "jsonFlickrApi(".length
    var range = NSMakeRange(0,len)
    
    string.deleteCharactersInRange(range)
    range = NSMakeRange((string.length - 1), 1)
    string.deleteCharactersInRange(range)
    
    return string
}

// -----------------------------------------------------------------------------------------------------

func fetchResponseWithURL(url:NSURL) -> NSData {
    let request:NSURLRequest = NSURLRequest(URL:url)
    var response:NSURLResponse?
    var error:NSError?
    
    let data = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)! as NSData;
    
    return data
}
