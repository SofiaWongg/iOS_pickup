//
//  ActivityRow.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/21/23.
//

import SwiftUI

struct ActivityRow: View {
    var activity: Act
    var body: some View {
        HStack{
//            activity.image
//                .resizable()
//                .frame(width:50, height:50)
            Text(activity.name)
            Spacer()
//            if activity.isFavorite {
//                Image(systemName: "star.fill")
//                    .foregroundColor(.yellow)
//            }
            }
        }
    }

struct ActivityRow_Previews: PreviewProvider {
    //static var activity = ModelData().activity
    static var previews: some View {
        var currentActivity: Act = Act(activity_id: "123", name: "soccer game", location: "123 ave", description: "blah blah blah", category: "soccer", participants: 3, is_private: true, is_recurring: false)
        ActivityRow(activity: currentActivity)
        //ActivityRow(activity: activity[1])
    }
}
