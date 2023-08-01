//
//  ProfileHost.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/12/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore



struct ProfileHost: View {
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData
    @State private var draftProfile = Profile.default
    @Binding var isLoggedIn: Bool
    @State private var fetchedProfile: Profile?
    @State private var doneFetching: Bool = false
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        
            VStack(alignment: .leading, spacing: 20) {
                HStack {
    //                Button("Sign out", action: isLoggedIn = false)
                    Button(action: { isLoggedIn = false }) {
                                        Text("Sign out")
                                    }
                    if editMode?.wrappedValue == .active {
                        Button("Cancel", role: .cancel) {
                            draftProfile = modelData.profile
                            editMode?.animation().wrappedValue = .inactive
                        }
                    }
                    Spacer()
                    EditButton()
                }
                if editMode?.wrappedValue == .inactive {
                    ProfileSummary(profile: fetchedProfile ?? modelData.profile)
                } else {
                    ProfileEditor(profile: $draftProfile)
                        .onAppear {
                                            draftProfile = fetchedProfile ?? Profile.default
                                }
                        .onDisappear {
                            fetchedProfile = draftProfile
                            //print(fetchedProfile!.userID)//poblem updating database
                            let userId = Auth.auth().currentUser?.uid
                            let userRef = db.collection("users").whereField("user_id", isEqualTo: userId!)
                            
                            //this gets the document
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
                                
                                // Updates the document - bio and username
                                documentRef.updateData(["username": draftProfile.username, "bio": draftProfile.bio]) { error in
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
        
            .padding()
            .task {
                //this is where I am trying to call the function from inside the view
                let userId = Auth.auth().currentUser?.uid
                UserManager.shared.fetchUser(uid: userId!) { userProfile in
                    fetchedProfile = userProfile
                    draftProfile=fetchedProfile!
                    
                    //print(fetchedProfile?.email)//this print statement returns the correct email but surrounded by Optional()
                
                }
                    
        }
        }
        
   
    
   
    
    
        
    
    
    
}




struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost(isLoggedIn: .constant(false))
            .environmentObject(ModelData())
    }
}
