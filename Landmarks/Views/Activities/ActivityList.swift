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
    @State private var showAttendingOnly = false
    @State private var showingProfile = false
    @Binding var isLoggedIn:Bool
    let db = Firestore.firestore()
    @State private var filteredActivity: [Act] = []
    @State private var userAttending: [String] = []
    @State private var matchedActivities: [Act] = []
    @State var statusChanged: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showAttendingOnly) {
                                    Text("Attending only")
                                }
                // Add your toggle and other UI elements here if needed
                if showAttendingOnly {
                    ForEach(matchedActivities) { activity in
                        NavigationLink(destination: ActivityDetail(activity: activity, statusChanged: $statusChanged)) {
                            ActivityRow(activity: activity)
                        }
                    }
                }
                else{
                    ForEach(filteredActivity) { activity in
                        NavigationLink(destination: ActivityDetail(activity: activity, statusChanged: $statusChanged)) {
                            ActivityRow(activity: activity)
                        }
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
                NavigationLink(destination: ActivityCreator(filteredActivity: $filteredActivity, statusChanged: $statusChanged)){
                    Label("Create New Activity", systemImage: "plus.app")
                }
                
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost(isLoggedIn: $isLoggedIn)
                    .environmentObject(modelData)
            }
            
            //to call a funtion you need to return stuff for no reason?
            let _ = updateInfo()
        }
        .onAppear {

            ActivityManager.shared.fetchActivities { (activities, error) in
                if let error = error {
                    print("Error fetching activities: \(error)")
                } else if let activities = activities {
                    filteredActivity = activities // Store the fetched activities in the @State variable
                    matchedActivities = filteredActivity.filter { activity in
                        userAttending.contains(activity.activity_id)}
                }
            }
            guard let userId = Auth.auth().currentUser?.uid else {
                    print("User not authenticated.")
                    return
                }
            UserManager.shared.fetchUser(uid: userId){userProfile in
                let user: Profile  = userProfile!
                userAttending = user.attending_list
            }
        }
    }
    
    func updateInfo( ) {
        ActivityManager.shared.fetchActivities { (activities, error) in
            if let error = error {
                print("Error fetching activities: \(error)")
            } else if let activities = activities {
                filteredActivity = activities // Store the fetched activities in the @State variable
                matchedActivities = filteredActivity.filter { activity in
                    userAttending.contains(activity.activity_id)}
            }
        }
        guard let userId = Auth.auth().currentUser?.uid else {
                print("User not authenticated.")
                return
            }
        UserManager.shared.fetchUser(uid: userId){userProfile in
            let user: Profile  = userProfile!
            userAttending = user.attending_list
        }
        return
    }
}

struct ActivityList_Previews: PreviewProvider {
    static var previews: some View {
        var _: Act = Act(activity_id: "123", name: "soccer game", location: "123 ave", description: "blah blah blah", category: "soccer", participants: 3, is_private: true, is_recurring: false, participants_list: [])
        ActivityList(isLoggedIn: .constant(false))
            .environmentObject(ModelData())
    }
}
