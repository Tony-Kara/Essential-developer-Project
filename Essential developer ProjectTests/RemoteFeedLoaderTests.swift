//
//  RemoteFeedLoaderTests.swift
//  Essential developer ProjectTests
//
//  Created by mac on 8/11/21.
//

import XCTest

class RemoteFeedLoader {
    func load() {
        HTTPClient.shared.get(from: URL(string: "https://a-url.com")!)
    }
}

    // we do not want to requestedURL from HTTPClient in production code, this is for test purpose only, changing the singleton from let to var
    // ensure we have other possiblity which is to create a subclass of the http client, so we move the test logic from HTTPClient to HTTPClientSpy
class HTTPClient {
    static var shared = HTTPClient()
   
    
    func get(from url: URL) {}
    

}


class HTTPCLientSpy: HTTPClient {
    override func get(from url: URL){
        requestedURL = url
    }
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let client = HTTPCLientSpy()
        HTTPClient.shared = client
        _ = RemoteFeedLoader()
        XCTAssertNil(client.requestedURL)
        
    }
    
    
    func test_load_RequestDataFromURL(){
        // the idea is to request for URL throught the client
        let client = HTTPCLientSpy()
        // overiride the shared property
        HTTPClient.shared = client
        let sut = RemoteFeedLoader()
        
        sut.load()
        XCTAssertNotNil(client.requestedURL)
        
    }
    
    
    
}
