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
      // i created a stub of the instance "client" here
        var capturedErrors = [RemoteFeedLoader.Error]() //enum Error is introduced to enable us bring in the ".connectivity" error from the FeedLoader Class, so i am checking if the                // capturedError is also of the type .connnectivity error. The array is to ensure that we only receive one error.
                                                  
        sut.load { error in capturedErrors.append(error) }
       let  clientError = NSError(domain: "Test", code: 0)
        client.completions[0](clientError) // we invoke the completions array with the clientError.
        
        XCTAssertEqual(capturedErrors, [.connectivity]) // Now, i will check to confirm that the captured load error is equal to the .connectivity error when the sut.load                                                    // function is invoked
    }
    
                                                                            //this is a turple, and i have to return it
    private func makeSUT(url: URL = URL(string: "https://a-url.com")!) -> (sut: RemoteFeedLoader, client: HTTPCLientSpy) {
        
        let client = HTTPCLientSpy() //created inside the function which means there is no need to pass it as an argument
        let sut =  RemoteFeedLoader(url: url, client: client)
        return (sut, client)
    }
    
   private class HTTPCLientSpy: HTTPClient { // this will not be part of production code, it serves as a means to pass in my url
    
    var requestedURLs = [URL]()
   
    var completions = [(Error) -> Void]() // created an array of all the completion blocks passed, holding an annonymous function with is of Error datatype
    func get(from url: URL, completion: @escaping (Error) -> Void){
        
        // we deleted an error from the client stub initially created to avoid stubbing.
        completions.append(completion) // pass in the closure/completion received, i think we will receive all the errors here and add to the completions array, we are capturing values
                                        // instead of stubbing
        requestedURLs.append(url)
        }
       
    }
}
