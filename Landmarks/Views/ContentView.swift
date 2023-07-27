//
//  ContentView.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: Tab = .featured
    @Binding var isLoggedIn:Bool
    enum Tab {
        case featured
        case list
    }
    var body: some View {
        TabView(selection: $selection) {
            ActivityList(isLoggedIn: $isLoggedIn)
                .tabItem{(Label("List", systemImage: "list.bullet"))}
                .tag(Tab.list)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isLoggedIn: .constant(false))
            .environmentObject(ModelData())
    }
}
