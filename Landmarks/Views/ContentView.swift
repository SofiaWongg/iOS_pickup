//
//  ContentView.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .list
    @Binding var isLoggedIn: Bool
    @State private var activities: [Act] = []
    @State private var needsRefresh = false
    @State private var selectedActivity: Act? = nil
    @State var statusChanged: Bool = false
    
    enum Tab {
        case list
        case map
    }
    
    var body: some View {
      if let selectedActivity = selectedActivity{
        ActivityDetail(selectedActivity: $selectedActivity, statusChanged: $statusChanged, onRefreshNeeded: {}, sourceView: .list, activity: selectedActivity)
      }
      else{
        Group{
          TabView(selection: $selection) {
              ActivityList(
                  isLoggedIn: $isLoggedIn,
                  activities: $activities,
                  onRefreshNeeded: { needsRefresh = true },
                  selectedActivity: $selectedActivity
              )
              .tabItem { Label("List", systemImage: "list.bullet") }
              .tag(Tab.list)
              
            MapView(activities: $activities, selectedActivity: $selectedActivity)
                  .tabItem { Label("Map", systemImage: "map") }
                  .tag(Tab.map)
          }
          .onAppear(perform: fetchActivities)
          .onChange(of: needsRefresh) {
              if needsRefresh {
                  fetchActivities()
                  self.needsRefresh = false
              }
          }
        }
      }

    }
    
    private func fetchActivities() {
        ActivityManager.shared.fetchActivities { (fetchedActivities, error) in
            if let error = error {
                print("Error fetching activities: \(error)")
                return
            }
            
            if let fetchedActivities = fetchedActivities {
                self.activities = fetchedActivities
            }
        }
    }
}
  
  struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
      ContentView(isLoggedIn: .constant(false))
        .environmentObject(ModelData())
    }
  }
