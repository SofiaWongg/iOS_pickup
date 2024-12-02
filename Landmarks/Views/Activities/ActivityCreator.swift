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
    @State private var location: String = "" //human readable - to remove
    //category needs to be an option not a free input
    @State private var category: String = ""
    @State private var is_private: Bool = false
    @State private var is_recurring: Bool = false
    @State private var start_time = Date()
    @Binding var filteredActivity: [Act]
    @State private var showingAlert = false
    @Binding var statusChanged: Bool
    @Environment(\.presentationMode) var presentationMode
    @State var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) // Default coordinates
  @State var showLocationPicker: Bool = false
  @State var searchText: String = ""
  @State private var searchQuery: String = ""
     @State private var searchResults: [(String, CLLocationCoordinate2D)] = []
     private var searchCompleter: MKLocalSearchCompleter = MKLocalSearchCompleter()
     
  
  public init(filteredActivity: Binding<[Act]>, statusChanged: Binding<Bool>) {
      self._filteredActivity = filteredActivity
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
                Button("Choose Meeting Point") {
                  showLocationPicker = true
                }
                Text(location.isEmpty ? "No location selected" : location)
                
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
                   LocationPicker(
                       searchText: $searchText,
                       searchResults: $searchResults,
                       location: $location,
                       coordinates: $coordinates,
                       showLocationPicker: $showLocationPicker
                   )
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
            "latitude": coordinates.latitude,
            "longitude": coordinates.longitude
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
