//
//  News.swift
//  Hola Frogger
//
//  Created by Sai Raghu Varma Kallepalli on 8/10/20.
//  Copyright © 2020 Varma. All rights reserved.
//

// Structure to hold the News data.
struct JsonResponse: Codable {
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
