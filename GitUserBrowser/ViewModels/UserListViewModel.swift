//
//  UserListViewModel.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation
import Combine

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var showError = false
    @Published var lastUpdated: Date?
    
    private let userService: UserServiceProtocol
    private var isAPICallActive = false
    
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter { $0.login.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func fetchUsers() async {
        // Inject mock data during UI tests
        if CommandLine.arguments.contains("-UITestMock") {
            await MainActor.run {
                self.users = [
                    User(login: "mojombo", avatar_url: "", name: "Tom Preston", followers: 1200, following: 300)
                ]
                self.lastUpdated = Date()
                self.isLoading = false
                self.isAPICallActive = false
            }
            return
        }
        
        if isAPICallActive { return }
        isAPICallActive = true
        isLoading = true
        
        do {
            let fetchedUsers = try await userService.fetchUsers()
            users = fetchedUsers
            lastUpdated = Date()
        } catch let apiError as APIError {
            error = apiError
            showError = true
        } catch {
            self.error = APIError.networkError(error)
            showError = true
        }
        
        isLoading = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { // Resetting the API flag after a delay
            self.isAPICallActive = false
        }
    }
}
