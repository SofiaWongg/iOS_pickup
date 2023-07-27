//
//  ActivityDetail.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/22/23.
//

import SwiftUI
import FirebaseFirestore

struct ActivityDetail: View {
    var activity: Act // Use Act instead of Activity

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Category: \(activity.category)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("About \(activity.name)")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text(activity.description)
                        .font(.body)
                }
            }
            .padding()
        }
        .navigationTitle(activity.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ActivityDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    
    // Make sure ModelData provides an array of Act instances
    static var previews: some View {
        var currentActivity: Act = Act(activity_id: "123", name: "soccer game", location: "123 ave", description: "blah blah blah", category: "soccer", participants: 3, is_private: true, is_recurring: false)
        ActivityDetail(activity: currentActivity) // Use modelData.acts instead of modelData.activity
            .environmentObject(modelData)
    }
}
