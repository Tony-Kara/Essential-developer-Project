//
//  RemoteFeedLoaderTests.swift
//  Essential developer ProjectTests
//
//  Created by mac on 8/11/21.
//

import XCTest

class RemoteFeedLoader {
    
    let client : HTTPClient
    let url: URL
    
    init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
    func load() {
        client.get(from: url)
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
        let url = URL(string: "https://a-url.com")!
        _ = RemoteFeedLoader(url: url ,client: client)
        XCTAssertNil(client.requestedURL)
        
    }
    
    
    func test_load_RequestDataFromURL(){
        // the idea is to request for URL throught the client
        let client = HTTPCLientSpy()
        let url = URL(string: "https://a-given-url.com")
        let sut = RemoteFeedLoader(url: url! , client: client)
        
        sut.load()
        XCTAssertEqual(client.requestedURL, url)
        
    }
    
    
    
}
