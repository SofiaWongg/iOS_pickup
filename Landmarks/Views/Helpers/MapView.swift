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
  @Binding var activities: [Act]
  @State var statusChanged = false//currently unused - probably make this a published var in content view
  @State var selection: String? = nil
  
  var selectedActivity: Act? {
          guard let selection = selection else { return nil }
          return activities.first { $0.activity_id == selection }
      }
  
  var body: some View {
    if let selectedActivity = selectedActivity{
      ActivityDetail(activity: selectedActivity, statusChanged: $statusChanged, onRefreshNeeded: {})
    }
    else{

      Group{
        Map(position: $cameraPosition, selection: $selection) {
          UserAnnotation() //TODO: add marker links for each activity
          ForEach(activities) { activity in
            Marker(activity.name, coordinate: activity.locationCoordinate)
              .tag(activity.activity_id)
          }
        }
        .mapControls{MapUserLocationButton()}
        .onAppear {
          manager.requestWhenInUseAuthorization() //requesting location if not already given
        }
      }
    }
    
  }
  
  
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(activities: .constant(mockActivities))
  }
}
