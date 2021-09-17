//
//  Character.swift
//  Marvel
//
//  Created by shuynh on 9/15/21.
//

import Foundation

struct Character: Codable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    let path: String
    let ext: String
    
    var completeURL: URL? {
        return URL(string: path + "." + self.ext)
    }
    
    enum CodingKeys: String, CodingKey {
        case path
        case ext = "extension"
    }
}

struct CharacterDetail: Decodable {
    var id: Int
    var title: String
    var thumbnail: Thumbnail?
}

struct CharacterResponse: Decodable {
    let data: ResponseData
    
    struct ResponseData: Decodable {
        let results: [Character]
        let offset: Int
        let limit: Int
        let total: Int
    }
}

struct DetailResponse: Decodable {
    let data: ResponseData
    
    struct ResponseData: Decodable {
        let offset: Int
        let limit: Int
        let total: Int
        let results: [CharacterDetail]
    }
}
