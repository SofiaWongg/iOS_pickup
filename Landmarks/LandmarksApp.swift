//
//  LandmarksApp.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/1/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct LandmarksApp: App {
    init() {
       FirebaseApp.configure()
       let user = Auth.auth().currentUser
       isLoggedIn = (user != nil)
    }
    @StateObject private var modelData = ModelData()
    @AppStorage("isLoggedIn") private var isLoggedIn = false
    //possibly make a class or service for this in the future
    //read about property wrppers and projected values $$$
    //@State new
    //@State Object - swift manages data - for reference types
    //@binding
    //try not to use observable object
    var body: some Scene {
        WindowGroup {
//            if isLoggedIn{
//                ContentView(isLoggedIn: $isLoggedIn)
//                    .environmentObject(modelData)
//            }
//            else{
//                LoginView(isLoggedIn: $isLoggedIn)
//            }
          MapView();
        }
    }
}
