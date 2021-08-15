//
//  RemoteFeedLoader.swift
//  Essential developer Project
//
//  Created by mac on 8/12/21.
//

import Foundation

public protocol HTTPClient {
   
    func get(from url: URL, completion: @escaping (Error) -> Void) //Remember, the HTTPClientSpy will adopt this protocol, it will implement the get() function and will
                                                                    // store the url that is passed to it as an array of url.

}


public class RemoteFeedLoader {
  
 private  let url: URL
 private  let client : HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
    }

                        // inject an instance of HTTPClient using dependency injection
   public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
                                                    // pass in default statement to the closure so it other tests like test_load_RequestsDataFromURL does not break
    public func load(completion: @escaping (Error) -> Void) {
        client.get(from: url) { error in // i noticed the error value is not used in the closure statement/ block or codes to run
            completion(.connectivity) // here, we are passing the domain error from the RemoteFeedLoader, closure is escaping leave the body of the function
        }
       
    }
}
