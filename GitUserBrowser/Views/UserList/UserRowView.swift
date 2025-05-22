//
//  UserRowView.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import SwiftUI
import Kingfisher

struct UserRowView: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 16) {
            KFImage(user.avatarURL)
                .placeholder {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            Text(user.login)
                .font(.body)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
