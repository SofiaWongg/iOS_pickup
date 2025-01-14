//
//  ActivityManager.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/18/23.
//

import Foundation
import FirebaseFirestore


//new strat: holds the activities as well -> view model strategy
//activity manager -> observable object
//activities need to be @published -> reference in in swift - need o refresh

final class ActivityManager {
    static let shared = ActivityManager()

    private init() { }

    func fetchActivities(completion: @escaping ([Act]?, Error?) -> Void) {
        var actList: [Act] = []
        let db = Firestore.firestore()
        db.collection("activities").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(nil, err)
            } else {
                for document in querySnapshot!.documents {
                  let coordinates = Act.Coordinates(
                      latitude: document.data()["latitude"] as? Double ?? 0.0,
                      longitude: document.data()["longitude"] as? Double ?? 0.0
                  )
                  
                    let currentActivity = Act(activity_id: document.documentID,
                                              name: document.data()["name"] as? String ?? "",
                                              location_description: document.data()["address"] as? String ?? "",
                                              description: document.data()["description"] as? String ?? "",
                                              category: document.data()["category"] as? String ?? "",
                                              participants: document.data()["participants"] as? Int ?? 0,
                                              is_private: document.data()["is_private"] as? Bool ?? false,
                                              is_recurring: document.data()["is_recurring"] as? Bool ?? false,
                                              participants_list: document.data()["participant_list"] as? [String] ?? [],
                                              address: document.data()["address"] as? String ?? "No address provided",
                                              coordinates: coordinates)
                                              
                    actList.append(currentActivity)
                    print("\(document.documentID) => \(document.data())")
                }
                completion(actList, nil)
            }
        }
    }
}

