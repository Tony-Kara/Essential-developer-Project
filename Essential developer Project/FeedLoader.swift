//
//  FeedLoader.swift
//  Essential developer Project
//
//  Created by mac on 8/11/21.
//

import Foundation

enum LoadFeedResult {
    case success([FeedItem])
    case error(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void)
}
