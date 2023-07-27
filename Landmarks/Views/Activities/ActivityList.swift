//
//  ActivityList.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore

struct ActivityList: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @State private var showingProfile = false
    @Binding var isLoggedIn:Bool
    
    let db = Firestore.firestore()
    @State private var filteredActivity: [Act] = []
   
    
    var body: some View {
        NavigationView {
            List {
                // Add your toggle and other UI elements here if needed
                ForEach(filteredActivity) { activity in
                    NavigationLink(destination: ActivityDetail(activity: activity)) {
                        Text(activity.name)
                        Text(activity.category)
                    }
                }
            }
            .navigationTitle("Activity in your area")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
                
                //make a button to get to add new activity
                //$ is for reference types - projected value - state->binding
                NavigationLink(destination: ActivityCreator(filteredActivity: $filteredActivity)){
                    Label("Create New Activity", systemImage: "plus.app")
                }
                
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost(isLoggedIn: $isLoggedIn)
                    .environmentObject(modelData)
            }
            
            
        }
        .onAppear {
            print("has appeared")
            ActivityManager.shared.fetchActivities { (activities, error) in
                if let error = error {
                    print("Error fetching activities: \(error)")
                } else if let activities = activities {
                    filteredActivity = activities // Store the fetched activities in the @State variable
                }
            }
        }
    }
}


struct ActivityList_Previews: PreviewProvider {
    static var previews: some View {
        var currentActivity: Act = Act(activity_id: "123", name: "soccer game", location: "123 ave", description: "blah blah blah", category: "soccer", participants: 3, is_private: true, is_recurring: false)
        ActivityList(isLoggedIn: .constant(false))
            .environmentObject(ModelData())
    }
}
