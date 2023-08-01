//
//  ActivityCreator.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/25/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct ActivityCreator: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var location: String = ""
    //category needs to be an option not a free input
    @State private var category: String = ""
    @State private var is_private: Bool = false
    @State private var is_recurring: Bool = false
    @State private var start_time = Date()
    @Binding var filteredActivity: [Act]
    @State private var showingAlert = false
    @Binding var statusChanged: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Create A New Activity!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            List {
                HStack {
                    Text("Name").bold()
                    Divider()
                    TextField("Enter name", text: $name)
                }
                HStack {
                    Text("Description").bold()
                    Divider()
                    TextField("Enter description", text: $description)
                }
                HStack {
                    Text("Location").bold()
                    Divider()
                    TextField("Enter location", text: $location)
                }
                HStack {
                    Text("category").bold()
                    Divider()
                    TextField("Enter category", text: $category)
                }
                Toggle(isOn: $is_private) {
                    Text("Make Activity Private").bold()
                }
                Toggle(isOn: $is_recurring) {
                    Text("Make Recurring").bold()
                }
            }
            DatePicker(selection: $start_time) {
                            Text("Start time").bold()
                        }
            }
            .padding()
            
        
        Button(action: {
                   Task {
                       do {
                           try await createNewActivity()
                           // Optionally, you can add code here to handle the success case
                           self.presentationMode.wrappedValue.dismiss()
                       } catch {
                           // Handle the error here
                           print("Error creating activity: \(error)")
                       }
                   }
               }) {
                   Text("Submit")
    
        }
        }
    func createNewActivity() async throws {
        var id_string: String = NSUUID().uuidString
        var activityData: [String: Any] = [
            "id": id_string,
            "activity_id": id_string,
            "name": name,
            "location": location,
            "description": description,
            "is_private": is_private,
            "is_recurring": is_recurring,
            "category": category,
            "participants": 1,
            "participant_list":[],
        ]
        
        var currentAct: Act = Act(activity_id: id_string, name: name, location: location, description: description, category: category, participants: 1, is_private: is_private, is_recurring: is_recurring, participants_list: [])
        
        filteredActivity.append(currentAct)
        statusChanged = true
        let activityCollection = Firestore.firestore().collection("activities")
        
        // Check if the users collection already exists
        let collectionExists = try await activityCollection.limit(to: 1).getDocuments().isEmpty == false
        
        if !collectionExists {
            // Create the users collection if it doesn't exist
            try await activityCollection.addSnapshotListener { _, _ in }
        }
        
        // Create the new user document
        try await activityCollection.document(id_string).setData(activityData, merge: false)
        }
    }
    

    
struct ActivityCreator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityCreator(filteredActivity: .constant([]), statusChanged: .constant(true))
    }
}
