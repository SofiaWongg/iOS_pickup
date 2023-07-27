//
//  ProfileSummary.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/12/23.
//

import SwiftUI


struct ProfileSummary: View {
    var profile: Profile


    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text(profile.username)
                    .bold()
                    .font(.title)

                Text("Bio:") + Text(profile.bio)
                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
                Text("Goal Date: ") + Text(profile.goalDate, style: .date)
                Divider()


                               VStack(alignment: .leading) {
                                   Text("Completed Achievements")
                                       .font(.headline)


                                   ScrollView(.horizontal) {
                                       HStack {
                                           HikeBadge(name: "First Activity")
                                           HikeBadge(name: "Sports Day")
                                               .hueRotation(Angle(degrees: 90))
                                           HikeBadge(name: "Tenth Activity")
                                               .grayscale(0.5)
                                               .hueRotation(Angle(degrees: 45))
                                       }
                                       .padding(.bottom)
                                   }
                               }
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Recent Sports")
                        .font(.headline)
                    
                    Text("Placeholder for recent activities")
                }
            }
        }
    }
}


struct ProfileSummary_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSummary(profile: Profile.default)
            .environmentObject(ModelData())
    }
}
