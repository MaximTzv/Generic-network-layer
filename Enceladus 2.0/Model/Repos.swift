//
//  Repos.swift
//  Enceladus 2.0
//
//  Created by Maksim Tsvetkov on 11/29/18.
//  Copyright © 2018 Maksim Tsvetkov. All rights reserved.
//

//struct Repository {
//    let fullName: String
//    let description: String
//    let starsCount: Int
//    let url: String
//}
//
//extension Repository {
//    init?(from json: [String: Any]) {
//        guard
//            let fullName = json["full_name"] as? String,
//            let description = json["description"] as? String,
//            let starsCount = json["stargazers_count"] as? Int,
//            let url = json["html_url"] as? String
//            else { return nil }
//
//        self.init(fullName: fullName, description: description, starsCount: starsCount, url: url)
//    }
//}
//
//extension Repository: Equatable {
//    static func == (lhs: Repository, rhs: Repository) -> Bool {
//        return lhs.fullName == rhs.fullName
//            && lhs.description == rhs.description
//            && lhs.starsCount == rhs.starsCount
//            && lhs.url == rhs.url
//    }
//}


import Foundation

struct Repo {
    let fullName: String
    let description: String
    let starsCount: Int
    let url: String
}

extension Repo: Decodable {
    
    enum RepoCodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case starsCount = "stargazers_count"
        case url = "html_url"
    }
    
    init(from decoder: Decoder) throws {
        
        let repoContainer = try decoder.container(keyedBy: RepoCodingKeys.self)
        
        fullName = try repoContainer.decode(String.self, forKey: .fullName)
        description = try repoContainer.decode(String.self, forKey: .description)
        starsCount = try repoContainer.decode(Int.self, forKey: .starsCount)
        url = try repoContainer.decode(String.self, forKey: .url)
    }
}

struct RepoCollection {
    let items: [Repo]
}

extension RepoCollection: Decodable {
    
    private enum RepoCollectionKeys: String, CodingKey {
        case items
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RepoCollectionKeys.self)
        items = try container.decode([Repo].self, forKey: .items)
    }
}
