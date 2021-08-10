//
//  RemoteFeedLoaderTests.swift
//  Essential developer ProjectTests
//
//  Created by mac on 8/11/21.
//

import XCTest

class RemoteFeedLoader {
    
}


class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPClient()
        _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
        
    }
    
    
    
    
    
    
}
