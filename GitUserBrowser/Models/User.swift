//
//  User.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation

struct User: Codable, Hashable, Identifiable {
    var id: String { login }
    let login: String
    
    private let avatar_url: String
    var avatarURL: URL? {
        URL(string: avatar_url)
    }
    
    let name: String?
    let followers: Int?
    let following: Int?
    
    init(login: String, avatar_url: String, name: String?, followers: Int?, following: Int?) {
        self.login = login
        self.avatar_url = avatar_url
        self.name = name
        self.followers = followers
        self.following = following
    }
}
