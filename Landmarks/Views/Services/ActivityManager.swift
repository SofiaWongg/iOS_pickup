//
//  ActivityManager.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/18/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift


//new strat: holds the activities as well -> view model strategy
//activity manager -> observable object
//activities need to be @published -> reference in in swift - need o refresh

final class ActivityManager {
    static let shared = ActivityManager()

    private init() { }

    func createNewActivity(id: String, name: String, location: String, description: String, is_private: Bool, is_recurring: Bool, category: String, participants: Int) async throws {
        let activityData: [String: Any] = [
            "id": id,
            "name": name,
            "location": location,
            "description": description,
            "is_private": is_private,
            "is_recurring": is_recurring,
            "category": category,
            "participants": participants
        ]
        
        let activityCollection = Firestore.firestore().collection("activities")
        
        // Check if the users collection already exists
        let collectionExists = try await activityCollection.limit(to: 1).getDocuments().isEmpty == false
        
        if !collectionExists {
            // Create the users collection if it doesn't exist
            activityCollection.addSnapshotListener { _, _ in }
        }
        
        // Create the new user document
        try await activityCollection.document(id).setData(activityData, merge: false)
        }
    
    func fetchActivity(id: String, completion: @escaping(Act?)-> Void){
        let db = Firestore.firestore()
        db.collection("activities")
            .whereField("id", isEqualTo: id)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting user document: \(error)")
                    completion(nil)
                    return
                }
                guard let document = querySnapshot?.documents.first else {
                    print("Activity document does not exist")
                    completion(nil)
                    return
                }
                // Process the user data
                let activityData = document.data()
                let id = activityData["id"] as? String ?? ""
                let name = activityData["name"] as? String ?? ""
                let location = activityData["location"] as? String ?? ""
                let description = activityData["description"] as? String ?? ""
                let is_private = activityData["is_private"] as? Bool ?? false
                let is_recurring = activityData["is_recurring"] as? Bool ?? false
                let category = activityData["category"] as? String ?? ""
                let participants = activityData["participants"] as? Int ?? 0
                let participants_list = activityData["participants_list"] as? [String] ?? []
                let currentActivity = Act(activity_id: id, name: name, location: location, description: description, category: category, participants: participants, is_private: is_private, is_recurring: is_recurring, participants_list: participants_list)
                completion(currentActivity)
                //wont need completion anymore  
            }
    }
    
    func fetchActivities(completion: @escaping ([Act]?, Error?) -> Void) {
        var actList: [Act] = []
        let db = Firestore.firestore()
        db.collection("activities").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil, err)
            } else {
                for document in querySnapshot!.documents {
                    let currentActivity = Act(activity_id: document.documentID,
                                              name: document.data()["name"] as? String ?? "",
                                              location: document.data()["location"] as? String ?? "",
                                              description: document.data()["description"] as? String ?? "",
                                              category: document.data()["category"] as? String ?? "",
                                              participants: document.data()["participants"] as? Int ?? 0,
                                              is_private: document.data()["is_private"] as? Bool ?? false,
                                              is_recurring: document.data()["is_recurring"] as? Bool ?? false,
                                              participants_list: document.data()["participant_list"] as? [String] ?? [])
                    actList.append(currentActivity)
                    print("\(document.documentID) => \(document.data())")
                }
                completion(actList, nil)
            }
        }
    }
}

