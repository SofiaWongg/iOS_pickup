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
    @Binding var isLoggedIn: Bool
    @Binding var activities: [Act]
    @State private var userAttending: [String] = []
    @State private var matchedActivities: [Act] = []
    @State var statusChanged: Bool = false
    var onRefreshNeeded: () -> Void // Add this for triggering refresh in ContentView
  @State private var isLoading = false
    
    var filteredActivity: [Act] { activities }
    
    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showAttendingOnly) {
                    Text("Attending only")
                }
                
                if showAttendingOnly {
                    ForEach(matchedActivities) { activity in
                        NavigationLink(destination: ActivityDetail(activity: activity, statusChanged: $statusChanged, onRefreshNeeded: onRefreshNeeded)) {
                            ActivityRow(activity: activity)
                        }
                    }
                } else {
                    ForEach(filteredActivity) { activity in
                        NavigationLink(destination: ActivityDetail(activity: activity, statusChanged: $statusChanged, onRefreshNeeded: onRefreshNeeded)) {
                            ActivityRow(activity: activity)
                        }
                    }
                }
            }
            .navigationTitle("Activity in your area")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingProfile.toggle()
                    } label: {
                        Label("User Profile", systemImage: "person.crop.circle")
                    }
                    
                  NavigationLink(destination: ActivityCreator(statusChanged: $statusChanged)) {
                        Label("Create New Activity", systemImage: "plus.app")
                    }
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost(isLoggedIn: $isLoggedIn)
                    .environmentObject(modelData)
            }
        }
        .onAppear {
            updateUserAttendingList()
        }
        .onChange(of: statusChanged) {
            updateUserAttendingList()
            onRefreshNeeded()
        }
    }
    
    private func updateUserAttendingList() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated.")
            return
        }
      
        isLoading = true
      
        UserManager.shared.fetchUser(uid: userId) { userProfile in
          DispatchQueue.main.async {
                     if let user = userProfile {
                         self.userAttending = user.attending_list
                         self.matchedActivities = self.activities.filter { activity in
                             self.userAttending.contains(activity.activity_id)
                         }
                     }
                     self.isLoading = false
                 }
        }
    }
}

struct ActivityList_Previews: PreviewProvider {
    static var previews: some View {
        ActivityList(
            isLoggedIn: .constant(false),
            activities: .constant([]),
            onRefreshNeeded: {}
        )
        .environmentObject(ModelData())
    }
}
