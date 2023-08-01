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
        ZStack(alignment: .leading) {
            HStack{
                ZStack{
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.lightRed, .darkRed]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    VStack{
                        Text("2.3")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("miles")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 70, height: 70, alignment: .leading)
                
                VStack(alignment: .leading) {
                    Text(activity.name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .padding(.bottom, 5)
                    
                    
                    HStack(alignment: .center) {
                        Image(systemName: "mappin")
                        Text(activity.location)
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        CategoryPill(categoryName: activity.category)
                        
                    }

                }
            }
        }
    }
}
    
    struct ActivityRow_Previews: PreviewProvider {
        //static var activity = ModelData().activity
        static var previews: some View {
            let currentActivity: Act = Act(activity_id: "123", name: "soccer game", location: "123 ave", description: "blah blah blah", category: "soccer", participants: 3, is_private: true, is_recurring: false, participants_list: [])
            ActivityRow(activity: currentActivity)
            //ActivityRow(activity: activity[1])
        }
    }

