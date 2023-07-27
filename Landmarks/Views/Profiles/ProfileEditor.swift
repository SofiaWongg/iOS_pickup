//
//  ProfileEditor.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/13/23.
//

import SwiftUI


struct ProfileEditor: View {
    @Binding var profile: Profile
    
    var dateRange: ClosedRange<Date> {
            let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
            let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
            return min...max
        }
    
    var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)
            }
            HStack {
                Text("Bio").bold()
                Divider()
                TextField("Tell people about yourself!", text: $profile.bio)
            }
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications").bold()
            }
        }
        DatePicker(selection: $profile.goalDate, in: dateRange, displayedComponents: .date) {
                        Text("Goal Date").bold()
                    }
    }
}


struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
