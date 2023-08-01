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
                VStack(alignment: .center, spacing: 10) {
                    Image("undraw_profile_pic_re_iwgo")
                        .resizable()
                        .scaledToFit()
                Text(profile.username)
                    .bold()
                    .font(.title)
//

                Text(profile.bio)
                Text("Notifications: \(profile.prefersNotifications ? "On": "Off" )")
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
