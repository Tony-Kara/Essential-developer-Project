//
//  RemoteFeedLoader.swift
//  Essential developer Project
//
//  Created by mac on 8/12/21.
//

import Foundation

public protocol HTTPClient {
   
    func get(from url: URL)

}


public class RemoteFeedLoader {
  
 private  let url: URL
 private  let client : HTTPClient

    
   public init(url: URL, client: HTTPClient) {
        self.client = client
        self.url = url
    }
    
  public  func load() {
        client.get(from: url)
    }
}
