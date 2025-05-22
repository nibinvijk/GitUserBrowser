# GitUserBrowser - SwiftUI

An iOS application that allows users to browse GitHub users and their repositories. This app demonstrates SwiftUI best practices, modern Swift concurrency, and clean architecture principles.

![UserList](https://github.com/user-attachments/assets/ebac7109-40df-4bc8-b542-3e145f422244)

![UserDetail](https://github.com/user-attachments/assets/b84f2597-1a04-4946-bfc3-c2130cb4aa08)

![RepoScreen](https://github.com/user-attachments/assets/9427ba2a-e297-46cb-99e3-7a3fb75b778c)


## Features

- Browse GitHub users
- View user profiles with follower and following counts
- Search for specific users
- Browse repositories for each user
- View repository details
- Open repositories in Safari
- Pull-to-refresh functionality
- Error handling
- Loading states

## Architecture

This app is built using the MVVM (Model-View-ViewModel) architecture to ensure separation of concerns:

- **Models**: Data structures that represent the core domain objects (User, Repository)
- **Views**: SwiftUI views responsible for UI rendering and user interactions
- **ViewModels**: Classes that handle business logic and data preparation for the views

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

## Installation

1. Open the project in Xcode:
   ```bash
   open GitHubBrowser.xcodeproj
   ```

2. (Optional) Configure GitHub API Token:
   - Create a `Keys.plist` file in the project
   - Add a string entry with key `AccessToken` and your GitHub personal access token as the value
   - This will increase the API rate limit

3. Build and run the app in the simulator or on a physical device

## External Dependencies

- **Kingfisher**: For efficient image loading and caching


## Project Structure

```
GitHubBrowser/
├── Models/
│   ├── Repository.swift
│   └── User.swift
├── ViewModels/
│   ├── UserListViewModel.swift
│   └── UserRepositoryViewModel.swift
├── Views/
│   ├── UserList
│   │   ├── UserListView.swift
│   │   └── UserRowView.swift
│   └── UserDetail
│       ├── UserDetailView.swift
│       └── RepositoryRowView.swift
├── Services/
│   ├── APIClient.swift
│   ├── APIError.swift
│   ├── UserService.swift
│   └── UserServiceProtocol.swift
├── Store/
│   ├── KeychainService.swift
│   └── FileManagerService.swift
└── Utilities/
│   └── SafariView.swift
└── GitUserBrowserApp.swift
```

## API Usage

The app uses the GitHub API to fetch user and repository data. The main endpoints used are:

- `/users` - Get a list of GitHub users
- `/users/{username}` - Get details for a specific user
- `/users/{username}/repos` - Get repositories for a specific user

## GitHub API Rate Limits

GitHub API has rate limits that may affect the app's functionality:

- Without authentication: 60 requests per hour
- With authentication: 5,000 requests per hour

To increase the rate limit, add your GitHub personal access token to the `Keys.plist` file.

## Future Enhancements

- Implement pagination for user and repository lists
- Add sorting and filtering options for repositories
- Support for dark mode customization
- Add GitHub authentication flow
- Add/Fix additional UI Tests


## Acknowledgements

- [GitHub API](https://docs.github.com/en/rest) for providing the data
- [Kingfisher](https://github.com/onevcat/Kingfisher) for image loading and caching

---
