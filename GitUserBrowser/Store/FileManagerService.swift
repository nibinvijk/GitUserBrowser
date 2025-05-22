//
//  FileManagerService.swift
//  GitUserBrowser
//
//  Created by Nibin Varghese on 16/05/25.
//

import Foundation

class FileManagerService {
    private static let plistFileName = "Keys"
    
    func getTokenFromPlist(fileName: String = plistFileName) -> String? {
        guard let plistPath = Bundle.main.path(forResource: fileName, ofType: "plist"),
              let plistData = FileManager.default.contents(atPath: plistPath),
              let plistDict = try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: AnyObject],
              let token = plistDict["AccessToken"] as? String else {
            return nil
        }
        return token
    }
}
