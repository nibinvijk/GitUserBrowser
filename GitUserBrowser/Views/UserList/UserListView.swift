//
//  UserListView.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import SwiftUI
import Combine

struct UserListView: View {
    @StateObject private var viewModel = UserListViewModel()
    @State private var selectedUser: User? = nil
    @State private var navigateToUserDetails = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(viewModel.filteredUsers) { user in
                        HStack {
                            UserRowView(user: user)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedUser = user
                            navigateToUserDetails = true
                        }
                        .accessibilityIdentifier("UserCell_\(user.login)") // for now only used for UI testing
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    await viewModel.fetchUsers()
                }
                .searchable(text: $viewModel.searchText, prompt: "Search users")
                .overlay {
                    if viewModel.isLoading && viewModel.users.isEmpty {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
                }
                
                NavigationLink(
                    destination: UserDetailView(user: selectedUser ?? User(login: "", avatar_url: "", name: "", followers: 0, following: 0)),
                    isActive: $navigateToUserDetails,
                    label: { EmptyView() }
                )
                .hidden()
            }
            .navigationTitle("GitHub Users")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        if let lastUpdated = viewModel.lastUpdated {
                            Text("Last updated: \(formattedDate(lastUpdated))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        } else {
                            Text("") // Empty text to ensure a view is always returned
                        }
                    }
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
                if viewModel.users.isEmpty {
                    await viewModel.fetchUsers()
                }
            }
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
