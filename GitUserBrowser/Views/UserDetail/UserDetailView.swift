//
//  UserDetailView.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import SwiftUI
import Kingfisher

struct UserDetailView: View {
    @StateObject private var viewModel: UserRepositoryViewModel
    @Environment(\.dismiss) private var dismiss // Required by SafariView
    @State private var selectedRepository: Repository? = nil
    @State private var showSafariView = false
    
    init(user: User) {
        _viewModel = StateObject(wrappedValue: UserRepositoryViewModel(user: user))
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 20) {
                    // User Profile
                    VStack(spacing: 16) {
                        KFImage(viewModel.user.avatarURL)
                            .placeholder {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                        
                        Text(viewModel.user.name ?? viewModel.user.login)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("@\(viewModel.user.login)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("\(viewModel.user.followers ?? 0)")
                                    .font(.headline)
                                Text("Followers")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            VStack {
                                Text("\(viewModel.user.following ?? 0)")
                                    .font(.headline)
                                Text("Following")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemBackground))
                    }
                    .padding(.horizontal)
                    
                    // Repositories
                    VStack(alignment: .leading) {
                        Text("Repositories")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if viewModel.repositories.isEmpty && !viewModel.isLoading {
                            Text("No repositories found")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            ForEach(viewModel.repositories) { repo in
                                RepositoryRowView(repository: repo)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                    .background {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.tertiarySystemBackground))
                                    }
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        selectedRepository = repo
                                        showSafariView = true
                                    }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.fetchUserDetails()
                        }
                    } label: {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
            .sheet(isPresented: $showSafariView) {
                if let url = selectedRepository?.repoURL {
                    SafariView(url: url)
                }
            }
            .alert(isPresented: $viewModel.showError, content: {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.error?.localizedDescription ?? "Unknown error occurred"),
                    dismissButton: .default(Text("OK"))
                )
            })
            .task {
                await viewModel.fetchUserDetails()
            }
            
            // Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.4)
                    .ignoresSafeArea(.all)
                
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)
            }
        }
    }
}
