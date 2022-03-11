//
//  Search.swift
//  Vivira
//
//  Created by Hamza Ahmed on 10/03/2022.
//


import Foundation

// MARK: - RepositoryModel
struct RepositoryModel: Codable {
    let totalCount: Int?
    let items: [Item]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case items
    }
}

// MARK: - Item
struct Item: Codable {
    let name, fullName: String?
    let owner: Owner?
    let htmlURL: String?
    let itemDescription: String?
  
    
    enum CodingKeys: String, CodingKey {
        case name
        case fullName = "full_name"
        case owner
        case htmlURL = "html_url"
        case itemDescription = "description"
    }
}

// MARK: - Owner
struct Owner: Codable {
    let login: String?
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
    }
}
