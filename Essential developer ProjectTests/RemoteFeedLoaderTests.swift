//
//  RemoteFeedLoaderTests.swift
//  Essential developer ProjectTests
//
//  Created by mac on 8/11/21.
//

import XCTest

class RemoteFeedLoader {
    
    var client : HTTPClient
    init(client: HTTPClient) {
        self.client = client
    }
    
    func load() {
        client.get(from: URL(string: "https://a-url.com")!)
    }
}

    // we do not want to requestedURL from HTTPClient in production code, this is for test purpose only, changing the singleton from let to var
    // ensure we have other possiblity which is to create a subclass of the http client, so we move the test logic from HTTPClient to HTTPClientSpy
protocol HTTPClient {
   
    func get(from url: URL)

}


class HTTPCLientSpy: HTTPClient {
     func get(from url: URL){
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPCLientSpy()
       
        _ = RemoteFeedLoader(client: client)
        XCTAssertNil(client.requestedURL)
        
    }
    
    
    func test_load_RequestDataFromURL(){
        // the idea is to request for URL throught the client
        let client = HTTPCLientSpy()
        
        let sut = RemoteFeedLoader(client: client)
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
        
    }
    
    
    
}
