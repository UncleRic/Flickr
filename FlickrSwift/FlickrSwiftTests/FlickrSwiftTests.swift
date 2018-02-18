//
//  FlickrSwiftTests.swift
//  FlickrSwiftTests
//
//  Created by Frederick C. Lee on 9/29/14.
//  Copyright (c) 2014 Frederick C. Lee. All rights reserved.
//

import UIKit
import XCTest

let urlString = "https://api.flickr.com/services/rest/?format=json&method=flickr.photos.search&extras=url_t,%20url_s,%20url_m,%20url_sq&text=Ric&api_key=ebbefd0c0a07c996f7867f014778adf7&"

class FlickrSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
     
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
