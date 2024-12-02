//
//  LocationPicker.swift
//  Landmarks
//
//  Created by Sofia Wong on 12/2/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationPicker: View {
  @Binding var searchText: String
  @Binding var searchResults:  [(String, CLLocationCoordinate2D)]
  @Binding var location: String
  @Binding var coordinates: CLLocationCoordinate2D
  @Binding var showLocationPicker: Bool
  
  
    var body: some View {
      Text("Search for a meeting point")
      TextField("Search for a meeting point", text: $searchText)
        .onChange(of: searchText){
        Task{
          searchResults = await searchForLocation(searchText: searchText)
        }
      }
      List(searchResults, id: \.0) { result in
        VStack{
          Text(result.0)
        }.onTapGesture {
          location = result.0
          coordinates = result.1
          showLocationPicker = false
        }} //id?
        .presentationDetents([ .large])
    }
}

func searchForLocation(searchText: String) async -> [(String,CLLocationCoordinate2D )] {
  var searchResults: [(String, CLLocationCoordinate2D)] = []
  let searchRequest = MKLocalSearch.Request()
  searchRequest.naturalLanguageQuery = searchText
  do {
    let search = MKLocalSearch(request: searchRequest)
    let response = try await search.start()
    
    for item in response.mapItems{
      searchResults.append((item.name ?? "No given name", item.placemark.coordinate))
    }
  } catch {
    print("Error searching for location: \(error.localizedDescription)")
  }
  return searchResults
}


#Preview {
    // Example preview with dummy bindings
    LocationPicker(
        searchText: .constant(""),
        searchResults: .constant([]),
        location: .constant(""),
        coordinates: .constant(CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)),
        showLocationPicker: .constant(true)
    )
}
