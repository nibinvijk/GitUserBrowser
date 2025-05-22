//
//  Repository.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation

struct Repository: Codable, Hashable, Identifiable {
    var id: String { name }
    let name: String
    let language: String?
    let starCount: Int
    let description: String?
    
    private let html_url: String
    var repoURL: URL? {
        URL(string: html_url)
    }
    
    let isFork: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case language
        case starCount = "stargazers_count"
        case description
        case html_url
        case isFork = "fork"
    }
    
    init(name: String, language: String?, starCount: Int, description: String?, html_url: String, isFork: Bool) {
        self.name = name
        self.language = language
        self.starCount = starCount
        self.description = description
        self.html_url = html_url
        self.isFork = isFork
    }
}
