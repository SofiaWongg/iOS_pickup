//
//  UserManager.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/3/23.
//

import Foundation
import FirebaseFirestore

final class UserManager {
    static let shared = UserManager()

    private init() { }

    func createNewUser(userId: String, username: String, email: String, password: String, bio: String, favorites: [String]) async throws {
        var userData: [String: Any] = [
            "user_id": userId,
            "username": username,
            "email": email,
            "password": password,
            "bio": bio,
            "favorites": favorites
        ]
        
        let usersCollection = Firestore.firestore().collection("users")
        
        // Check if the users collection already exists
        let collectionExists = try await usersCollection.limit(to: 1).getDocuments().isEmpty == false
        
        if !collectionExists {
            // Create the users collection if it doesn't exist
            try await usersCollection.addSnapshotListener { _, _ in }
        }
        
        // Create the new user document
        try await usersCollection.document(userId).setData(userData, merge: false)
        }
    
    func fetchUser(uid: String, completion: @escaping(Profile?)-> Void){
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("user_id", isEqualTo: uid)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error)")
                    completion(nil)
                    return
                }
                guard let document = querySnapshot?.documents.first else {
                    print("User document does not exist")
                    completion(nil)
                    return
                }
                // Process the user data
                let userData = document.data()
                let uid = userData["user_id"] as? String ?? ""
                let username = userData["username"] as? String ?? ""
                let password = userData["password"] as? String ?? ""
                let email = userData["email"] as? String ?? ""
                let bio = userData["bio"] as? String ?? ""
                let favorites = userData["favorites"] as? [Int] ?? []
                let prefersNotifications = userData["prefersNotifications"] as? Bool ?? false
                let attending_list = userData["attending_list"] as? [String] ?? []
                let currentUser = Profile(userID: uid, username: username, email: email, password: password, prefersNotifications: prefersNotifications, bio: bio, favorites: favorites, attending_list: attending_list)
                completion(currentUser)//use a completion handler or just return
                
                
            }
        
    }
    
}

