//  FlickrEnvironment.swift
//  FlickrSwift
//
//  Created by Frederick C. Lee on 10/15/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
// -----------------------------------------------------------------------------------------------------
import Foundation

let flickrAPIKey = "ebbefd0c0a07c996f7867f014778adf7"    // ...'Consumer Key'
let flickrAPISecret = "bf823c361bc6f09e"                 // ...'Consumer Secret'

let FKFlickrRESTAPI = "https://api.flickr.com/services/rest/"
let flickrBaseURL = "https://api.flickr.com/services/rest/?format=json&"

// ------------------------------------------------------------------------------------

let FKFlickrKitErrorDomain = "com.amourine.flickrkit.ErrorDomain"
let FKFlickrAPIErrorDomain = "com.amourine.flickrapi.ErrorDomain"

// ------------------------------------------------------------------------------------
// The Flickr API uses different parameter names.
// Instead of the Flickr API parameter names being hard-coded throughout, they are defined here as macros.
// The Flickr API parameters are defined as query string parameters on the HTTP GET request.

let flickrParamMethod = "method"
let flickrParamAppKey = "api_key"
let flickrParamUsername = "username"
let flickrParamUserid = "user_id"
let flickrParamPhotoSetId = "photoset_id"
let flickrParamExtras = "extras"
let flickrParamText = "text"
let flickrParamTag = "tags"

// ------------------------------------------------------------------------------------
//The Flickr API includes a parameter named method.
// This parameter defines which API method is called.
// The API methods supported by this simple wrapper are defined here as macros.

let flickrMethodFindByUsername = "flickr.people.findByUsername"
let flickrMethodGetPhotoSetList = "flickr.photosets.getList"
let flickrMethodGetPhotosWithPhotoSetId = "flickr.photosets.getPhotos"
let flickrMethodSearchPhotos = "flickr.photos.search"

// ====================================================================================
// Request Token:
let flickrRequestToken = "https://www.flickr.com/services/oauth/request_token?"

// User Authorization:
let flickrAuthorization = "https://www.flickr.com/services/oauth/authorize?"

// Access Token:
let flickrAccessToken = "https://www.flickr.com/services/oauth/access_token?"

// ====================================================================================
// Definitions:

// oauth_nonce: A random series of characters unique to this call to Flickr.
// If you have two users using the same web page that both make calls to Flickr at the same time then
// the timestamp will be the same, but the oauth_nonce must be different.
// ------------------------------------------------------------------------------------
// oauth_timestamp: This is the number of seconds since 1/1/1970, sometimes called the unix epoch.
// Note, this time should always be calculated using GMT (or UTC) times, not local times.
// If your timestamp is not a current time (i.e. is more than an hour out) then Flickr will reject your call to the Flickr API.
// ------------------------------------------------------------------------------------
// oauth_callback: The callback URL in the Flickr API Keys settings is *** now ignored ***,
// and you sent the callback url every time you call the request_token endpoint.
// ------------------------------------------------------------------------------------
// oauth_version and oauth_signature_method: The version is always “1.0” and signature method for Flickr
// is always HMAC-SHA1 (although others are supported by the OAuth spec).
// ====================================================================================

// Ref: https://www.flickr.com/services/api/auth.oauth.html

//https://www.flickr.com/services/oauth/request_token
//?oauth_nonce=89601180
//&oauth_timestamp=1305583298
//&oauth_consumer_key=653e7a6ecc1d528c516cc8f92cf98611
//&oauth_signature_method=HMAC-SHA1
//&oauth_version=1.0
//&oauth_callback=http%3A%2F%2Fwww.example.com
// ------------------------------------
// Would have a base string that looks like the following:
// Concatenate all:
//GET&https%3A%2F%2Fwww.flickr.com %2F services%2Foauth %2F request_token
//  &oauth_callback%3Dhttp%253A%252F%252Fwww.example.com
//  %26 oauth_nonce %3D95613465
//  %26 oauth_consumer_key %3D 653e7a6ecc1d528c516cc8f92cf98611
//  %26 oauth_signature_method %3D HMAC-SHA1
//  %26 oauth_version %3D1.0
//  %26 oauth_timestamp %3D 1305586162

// =======================================================================================================================
// MARK: - OAUTH
let callbackKey = "oauth_callback"
let consumerKey = "oauth_consumer_key"
let nonceKey = "oauth_nonce"
let signatureKey = "oauth_signature_method"
let oauthVersionKey = "oauth_version"
let timeStampKey = "oauth_timestamp"

var timeStamp:TimeInterval {
    let seconds: TimeInterval = Date().timeIntervalSince1970
    return seconds
}

var nonce:String {
    let temp = UUID().uuidString
    let nonce = temp.replacingOccurrences(of: "-", with: "")
    return nonce as String
}

var callback:String {
    return "http://www.amourineTech.com/oauth/test"
}

public var oauthParameters:[String:String] {
    var myDict = [timeStampKey:"\(timeStamp)"]
    myDict[nonceKey] = nonce
    myDict[callbackKey] = callback
    myDict[signatureKey] = "HMAC-SHA1"
    myDict[oauthVersionKey] = "1"
    myDict[consumerKey] = flickrAPIKey
    return myDict
}

// -----------------------------------------------------------------------------------------------------
// To generate a SHA1 signature you require two things.
//   1) A Key:
//        For OAuth the signature key is made up of two parts, your consumer secret, and your token secret.
//   2) Base String:
//        The second part of the SHA1 signature generation is the base string.
//        For OAuth the base string is made up of three parts, (a) the HTTP method,
//        (b) the URL endpoint you are using, and (c) the parameters you are sending.
// -----------------------------------------------------------------------------------------------------

class OAuth: NSObject {
    
    var oauthParameters:[String:String]
    var SignatureSecret:String
    
    var accessToken:String? = nil
    var tokenSecret: String? = nil
    
    init(consumerKey:String, consumerSecret:String, accessToken:String?, tokenSecret:String?){
        
        self.SignatureSecret = String()
        self.oauthParameters = ["oauth_signature_method" : "SHA1"]
        
        if (self.accessToken != nil){
            self.oauthParameters.updateValue(accessToken!, forKey: "oauth_token")
        }
        
        if (tokenSecret != nil){
            self.SignatureSecret = "\(consumerSecret)&\(tokenSecret!)"
        } else {
            self.SignatureSecret = "\(consumerSecret)&"
        }
        
    }
}

// =======================================================================================================================
// MARK: - Flickr Methods

public func getURLForString(_ str:String, tags: String) -> URL? {
    let parameters = [flickrParamMethod : flickrMethodSearchPhotos,
                      flickrParamAppKey : flickrAPIKey,
                      flickrParamTag : tags,
                      flickrParamText : str, flickrParamExtras : "url_t, url_s, url_m, url_sq"]
    
    return buildFlickrURLWith(flickrBaseURL, parameters: parameters)
}

// -----------------------------------------------------------------------------------------------------

func buildFlickrURLWith(_ baseURL:String, parameters:Dictionary<String,String>) -> URL? {
    var urlString = baseURL
    for (key,value) in parameters {
        urlString += "\(key)=\(value)&"
    }
    if let urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
        let url = URL(string:urlString)
        return url
    }
    return nil
}



