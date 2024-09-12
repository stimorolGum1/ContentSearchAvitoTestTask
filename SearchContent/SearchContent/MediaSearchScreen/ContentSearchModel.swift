//
//  ContentSearchModel.swift
//  SearchContent
//
//  Created by Danil on 08.09.2024.
//

import Foundation

struct ContentSearchModel {
    
    var items: [Photo] = []
    var filteredHistory: [String] = []
}

struct UnsplashSearchResponse: Codable {
    let total: Int
    let totalPages: Int
    let results: [Photo]
    
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct Photo: Codable {
    let user: User
    let id: String
    let urls: PhotoUrls
    let altDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case user
        case id
        case urls
        case altDescription = "alt_description"
    }
}

struct PhotoUrls: Codable {
    let small: String
    let regular: String
}

struct User: Codable {
    let name: String
}
