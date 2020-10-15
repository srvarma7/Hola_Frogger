//
//  News.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 8/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

import Foundation

// Structure to hold the News data.
struct NewsJsonResponse: Codable {
    let articleCount: Int
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String
    let url: String
    let image: String?
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let name: String
    let url: String
}

extension NewsJsonResponse {
    static var all: Resource<NewsJsonResponse> = {
        let url = URL(string: "https://gnews.io/api/v3/search?q=endangered+frog&country=au&token=2e90adf5b191d077e1ae0d79a862cbcb")!
        return Resource(url: url)
    }()
}
