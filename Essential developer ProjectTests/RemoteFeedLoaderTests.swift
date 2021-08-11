//
//  RemoteFeedLoaderTests.swift
//  Essential developer ProjectTests
//
//  Created by mac on 8/11/21.
//

import XCTest
import Essential_developer_Project

    // we do not want to requestedURL from HTTPClient in production code, this is for test purpose only, changing the singleton from let to var
    // ensure we have other possiblity which is to create a subclass of the http client, so we move the test logic from HTTPClient to HTTPClientSpy




class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        
       
        let (_ , client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
        
    }
    
    
    func test_load_RequestsDataFromURL(){
        // the idea is to request for URL throught the client
        
        let url = URL(string: "https://a-given-url.com")
        let (sut, client)  = makeSUT(url: url!)
        
        sut.load()
        XCTAssertEqual(client.requestedURLs, [url])
        
    }
    
    func test_loadTwice_RequestsDataFromURLTwice(){
        // the idea is to request for URL throught the client
        
        let url = URL(string: "https://a-given-url.com")
        let (sut, client)  = makeSUT(url: url!)
        
        sut.load()
        sut.load()                            // accumulate all the requested url in an array
        XCTAssertEqual(client.requestedURLs, [url,url])
       
        
    }
    
                                                                            //this is a turple, and i have to return it
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPCLientSpy) {
        
        let client = HTTPCLientSpy() //created inside the function which means there is no need to pass it as an argument
        let sut =  RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
   private class HTTPCLientSpy: HTTPClient { // this will not be part of production code
    
    var requestedURLs = [URL]()
    func get(from url: URL){
        requestedURLs.append(url)
        }
       
    }
}
