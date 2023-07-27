//
//  Profile.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/12/23.
//

import Foundation

struct Profile {
    var userID: String
    var username: String
    var email: String
    var password: String
    var prefersNotifications: Bool
    var goalDate = Date()
    var bio: String
    var favorites: [Int]
    
    static let `default` = Profile(userID: "", username: "ssofia_w", email: "", password: "", prefersNotifications: true, bio: "", favorites: [])
    
}
