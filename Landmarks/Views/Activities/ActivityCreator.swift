//
//  ActivityCreator.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/25/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CoreLocation
import MapKit

struct ActivityCreator: View {
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var is_private: Bool = false
    @State private var is_recurring: Bool = false
    @State private var start_time = Date()
    @State private var location_description: String = ""
    @State private var showingAlert = false
    @Binding var statusChanged: Bool
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedLocation: SelectedLocation?
    @State var showLocationPicker: Bool = false
    @State var searchText: String = ""
    @State private var searchQuery: String = ""
     @State private var searchResults: [(String, String, CLLocationCoordinate2D)] = []
     private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
     
  init(statusChanged: Binding<Bool>) {
      self._statusChanged = statusChanged
  }
    
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
              VStack {
                Button(selectedLocation?.address != nil ? "Change Meeting Point" : "Choose Meeting Point") {
                  showLocationPicker = true
                }
                Text(selectedLocation?.address ?? "No location selected")
                Divider()
                Text("Location Description").bold()
                TextField("(Optional)", text: $location_description)
                
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
                      
                         
                      
                           self.presentationMode.wrappedValue.dismiss()
                       } catch {
                           // Handle the error here
                           print("Error creating activity: \(error)")
                       }
                   }
               }) {
                   Text("Submit")
    
        }
               .sheet(isPresented: $showLocationPicker) {
                 LocationPicker(selectedLocation: $selectedLocation, showLocationPicker: $showLocationPicker)
               }
        }
  
    func createNewActivity() async throws {
      let id_string: String = NSUUID().uuidString
      let activityData: [String: Any] = [
            "id": id_string,
            "activity_id": id_string,
            "name": name,
            "location_description": location_description,
            "description": description,
            "is_private": is_private,
            "is_recurring": is_recurring,
            "category": category,
            "participants": 1,
            "participant_list":[],
            "address" : selectedLocation?.address ?? "No location provided",
            "latitude": selectedLocation?.coordinate.latitude ?? 0.0,
            "longitude": selectedLocation?.coordinate.longitude ?? 0.0,
        ]
      
      let coordinates = Act.Coordinates(
          latitude: selectedLocation?.coordinate.latitude ?? 0.0,
          longitude: selectedLocation?.coordinate.longitude ?? 0.0
      )
        
      let currentAct: Act = Act(
          activity_id: id_string,
          name: name,
          location_description: location_description,
          description: description,
          category: category,
          participants: 1,
          is_private: is_private,
          is_recurring: is_recurring,
          participants_list: [],
          address: selectedLocation?.address ?? "No location provided",
          coordinates: coordinates
      )
        
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
        ActivityCreator(statusChanged: .constant(true))
    }
}
