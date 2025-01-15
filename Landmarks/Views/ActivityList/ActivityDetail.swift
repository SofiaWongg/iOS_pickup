//
//  ActivityDetail.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/22/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import Combine


enum SourceView{
  case map
  case list
}

struct ActivityDetail: View {
  @Binding var selectedActivity: Act? // Use Act instead of Activity
  @State private var joined: Bool = false
  @State private var numParticipants: Int = 1
  @Binding var statusChanged: Bool
  var onRefreshNeeded: () -> Void
  var sourceView: SourceView
  @State var activity: Act
  
  
  var body: some View {
    ScrollView {
      Button(action: {selectedActivity = nil}){
        HStack {
          Image(systemName: "chevron.left")
            .foregroundColor(.blue)
            .imageScale(.large)
          Text("Back")
            .foregroundColor(.blue)
            .font(.system(size: 17, weight: .regular))
          Spacer()
        }.padding(EdgeInsets(top: 5, leading: 15, bottom: 0, trailing: 0))
      }
      VStack(alignment: .leading, spacing: 20) {
        VStack(alignment: .leading, spacing: 8) {
          Image("undraw_game_day")
            .resizable()
            .scaledToFit()
          HStack{
            Text(activity.name)
              .font(.title)
              .fontWeight(.bold)
            Spacer()
            Button(action: {
              statusChanged = true
              joined.toggle()
              addParticipant(activity: activity)
            }) {
              Image(systemName: joined ? "person.fill.checkmark" : "person.2.circle")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(joined ? Color.green : Color.blue)
                .cornerRadius(10)
            }
          }
          Text("Category: \(activity.category)")
            .foregroundColor(.gray)
            .font(.subheadline)
          Text("Participants: \(numParticipants)")
            .foregroundColor(.gray)
            .font(.subheadline)
        }
        
        Divider()
        
        VStack(alignment: .leading, spacing: 8) {
          Text("About \(activity.name)")
            .font(.title2)
            .fontWeight(.semibold)
          Text(activity.address)
            .foregroundColor(.gray)
            .font(.subheadline)
          Text(activity.description)
            .font(.body)
        }
      }
      .padding()
    }
    .navigationTitle(activity.name)
    .navigationBarTitleDisplayMode(.inline)
    .onAppear{
      if let selectedActivity = selectedActivity{
        activity = selectedActivity
        numParticipants = selectedActivity.participants
      }
      guard let userId = Auth.auth().currentUser?.uid else {
        print("User not authenticated.")
        return
      }
      UserManager.shared.fetchUser(uid: userId){userProfile in
        let user: Profile  = userProfile!
        joined = user.attending_list.contains(activity.activity_id)
      }
      print(activity.participants)
      print(activity.participants_list)
    }
    .onDisappear{
      statusChanged = false
    }
  }
  
  
  
  func addParticipant(activity: Act) {
    //@Binding var num_participants: Int = num_participants
    let db = Firestore.firestore()
    guard let userId = Auth.auth().currentUser?.uid else {
      print("User not authenticated.")
      return
    }
    let activityRef = db.collection("activities").document(activity.activity_id)
    let userRef = db.collection("users").whereField("user_id", isEqualTo: userId)
    activityRef.getDocument { snapshot, error in
      if let error = error {
        print("Error fetching activity document: \(error)")
        return
      }
      
      guard let document = snapshot, document.exists else {
        print("Activity document not found.")
        return
      }
      
      var participantsList = document.data()?["participants_list"] as? [String] ?? []
      
      if participantsList.contains(userId) {
        // If user is already a participant, remove them from the list
        participantsList.removeAll { $0 == userId }
      } else {
        // If user is not a participant, add them to the list
        participantsList.append(userId)
      }
      numParticipants = participantsList.count
      activityRef.updateData([
        "participants_list": participantsList, "participants": participantsList.count
      ]) { error in
        if let error = error {
          print("Error updating participants list: \(error)")
        } else {
          print("Participant status updated successfully.")
          //num_participants = num_participants+1
          userRef.getDocuments { (querySnapshot, error) in
            if let error = error {
              print("Error getting user document: \(error)")
              return
            }
            
            guard let document = querySnapshot?.documents.first else {
              print("User document not found")
              return
            }
            
            let documentRef = document.reference
            var attendingList = document.data()["attending_list"] as? [String] ?? []
            
            if attendingList.contains(activity.activity_id) {
              // If user was already attending remove activity id from attending list
              attendingList.removeAll { $0 == activity.activity_id }
            } else {
              // If user is not attending, add this activity to their attending list
              attendingList.append(activity.activity_id)
            }
            //fetchParticipantNames(activity: activity)
            // Updates the document - attending list
            documentRef.updateData(["attending_list": attendingList]) { error in
              if let error = error {
                print("Error updating document: \(error)")
              } else {
                print("Document successfully updated!")
              }
            }
          }
        }
      }
    }
    
    
  }
}

func getParticipants(activity: Act)-> Int{
  return 1
}

struct ActivityDetail_Previews: PreviewProvider {
  static let modelData = ModelData()
  
  // Make sure ModelData provides an array of Act instances
  static var previews: some View {
    let coordinates = Act.Coordinates(latitude: 0.0, longitude: 0.0)
    var currentActivity: Act = Act( activity_id: "123",
                                    name: "soccer game",
                                    location_description: nil,
                                    description: "blah blah blah",
                                    category: "soccer",
                                    participants: 3,
                                    is_private: true,
                                    is_recurring: false,
                                    participants_list: [],
                                    address: "123 ave",
                                    coordinates: coordinates)
    ActivityDetail(selectedActivity: .constant(currentActivity), statusChanged: .constant(false), onRefreshNeeded: {}, sourceView: .list, activity: currentActivity) // Use modelData.acts instead of modelData.activity
      .environmentObject(modelData)
  }
}
