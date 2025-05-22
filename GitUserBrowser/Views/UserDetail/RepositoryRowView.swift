//
//  RepositoryRowView.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import SwiftUI

struct RepositoryRowView: View {
    let repository: Repository
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(repository.name)
                .font(.headline)
            
            HStack {
                if let language = repository.language {
                    Text(language)
                        .font(.subheadline)
                        .foregroundColor(.blue)
                } else {
                    Text("-")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                
                Spacer()
                
                Text("★ \(repository.starCount)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let description = repository.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            } else {
                Text("-")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}
