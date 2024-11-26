//
//  MapView.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/5/23.
//

import SwiftUI
import MapKit

struct MapView: View {
    let manager = CLLocationManager()
  @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
  @State private var fetchedActivities: [Act] = []
  
    var body: some View {
      Map(position: $cameraPosition){
        UserAnnotation()
      }
      .mapControls{MapUserLocationButton()}
        .onAppear {
            manager.requestWhenInUseAuthorization()
          ActivityManager.shared.fetchActivities { (activities, error) in
              if let error = error {
                  print("Error fetching activities: \(error)")
              } else if let activities = activities {
                  fetchedActivities = activities // Store the fetched activities in the @State variable
              }
          }
        }
    }
    

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
