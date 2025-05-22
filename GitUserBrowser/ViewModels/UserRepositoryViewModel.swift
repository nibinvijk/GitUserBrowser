//
//  UserRepositoryViewModel.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation
import Combine

@MainActor
class UserRepositoryViewModel: ObservableObject {
    @Published var user: User
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var error: APIError?
    @Published var showError = false
    
    private let userService: UserServiceProtocol
    private var isAPICallActive = false
    
    init(userService: UserServiceProtocol = UserService(), user: User) {
        self.userService = userService
        self.user = user
    }
    
    func fetchUserDetails() async {
        if isAPICallActive { return }
        isAPICallActive = true
        isLoading = true
        
        do {
            let updatedUser = try await userService.fetchDetails(for: user.login)
            self.user = updatedUser
            await fetchRepositories()
        } catch let apiError as APIError {
            error = apiError
            showError = true
            isLoading = false
            
            resetAPICallActiveFlagWithDelay()
        } catch {
            self.error = APIError.networkError(error)
            showError = true
            isLoading = false
            
            resetAPICallActiveFlagWithDelay()
        }
    }
    
    func fetchRepositories() async {
        do {
            let allRepositories = try await userService.fetchRepositories(for: user.login)
            // Only holding the repositories that are not forked
            repositories = allRepositories.filter { !$0.isFork }
        } catch let apiError as APIError {
            error = apiError
            showError = true
        } catch {
            self.error = APIError.networkError(error)
            showError = true
        }
        
        isLoading = false
        
        resetAPICallActiveFlagWithDelay()
    }
    
    private func resetAPICallActiveFlagWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            // Resetting the API flag after a delay
            self.isAPICallActive = false
        }
    }
}
