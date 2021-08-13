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
        // the idea is to request data from the RemoteFeedLoader and the client will make use of a URL
        
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
    
    func test_load_deliverErrorOnClientError(){
        
        let (sut, client) = makeSUT()
        client.error = NSError(domain: "Test", code: 0) // i created a stub of the instance "client" here
        var capturedErrors = [RemoteFeedLoader.Error]() //enum Error is introduced to enable us bring in the ".connectivity" error from the FeedLoader Class, so i am checking if the                // capturedError is also of the type .connnectivity error. The array is to ensure that we only receive one error.
                                                  
        sut.load { error in capturedErrors.append(error) }
        
        XCTAssertEqual(capturedErrors, [.connectivity]) // Now, i will check to confirm that the error .connectivity is equal to the captured error when the sut.load                                                    // function is invoked
    }
    
                                                                            //this is a turple, and i have to return it
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPCLientSpy) {
        
        let client = HTTPCLientSpy() //created inside the function which means there is no need to pass it as an argument
        let sut =  RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
   private class HTTPCLientSpy: HTTPClient { // this will not be part of production code, it serves as a means to pass in my url
    
    var requestedURLs = [URL]()
    var error: Error?
    func get(from url: URL, completion: @escaping (Error) -> Void){
        
        if let error = error {
            completion(error) // this error value is from the stub we created.
        }
        
        requestedURLs.append(url)
        }
       
    }
}
