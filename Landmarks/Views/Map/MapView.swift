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
  @State var selectedID: String? = nil
  @Binding var selectedActivity: Act?
  
  var body: some View {
    if let selectedActivity = selectedActivity{
      ActivityDetail(selectedActivity: $selectedActivity, statusChanged: $statusChanged, onRefreshNeeded: {}, sourceView: .map, activity: selectedActivity)
    }
    else{

      Group{
        Map(position: $cameraPosition, selection: $selectedID) {
          UserAnnotation() //TODO: add marker links for each activity
          ForEach(activities) { activity in
            Marker(activity.name, coordinate: activity.locationCoordinate)
              .tag(activity.activity_id)
          }
        }
        .mapControls{MapUserLocationButton()}
        .onChange(of: selectedID) {
                            if let newID = selectedID {
                                selectedActivity = activities.first { $0.activity_id == newID }
                            } else {
                                selectedActivity = nil
                            }
                        }
        .onAppear {
          manager.requestWhenInUseAuthorization() //requesting location if not already given
        }
      }
    }
    
  }
  
  
}

struct MapView_Previews: PreviewProvider {
  static var previews: some View {
    MapView(activities: .constant(mockActivities), selectedActivity: .constant(mockActivities[1]))
  }
}
