import SwiftUI
import CoreLocation
import MapKit
import Combine

struct LocationResult: Identifiable, Hashable {
  let id = UUID()
  let name: String
  let address: String
  let coordinate: CLLocationCoordinate2D
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  static func == (lhs: LocationResult, rhs: LocationResult) -> Bool {
    lhs.id == rhs.id
  }
}

@MainActor
class MapSearch: ObservableObject {
  
  private let locationManager = CLLocationManager()
  
  
  @Published var searchText: String = ""
  @Published var searchResults: [LocationResult] = []
  private var searchTask: Task<Void, Never>?
  
  //getting users location on startup
  init() {
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
  }
  
  func search() {
    searchTask?.cancel()
    
    guard !searchText.isEmpty else {
      searchResults = []
      return
    }
    
    searchTask = Task {
      do {
        try await Task.sleep(nanoseconds: 200_000_000)
        guard !Task.isCancelled else { return }
        
        let results = await searchForLocation(searchText: searchText)
        guard !Task.isCancelled else { return }
        
        await MainActor.run {
          self.searchResults = results
            .prefix(6) // Limit to top 6 results
            .map { name, address, coordinate in
              LocationResult(name: name, address: address, coordinate: coordinate)
            }
        }
      } catch {
        print("Search error: \(error)")
      }
    }
  }
  
  private func searchForLocation(searchText: String) async -> [(String, String, CLLocationCoordinate2D)] {
    var searchResults: [(String, String, CLLocationCoordinate2D)] = []
    let searchRequest = MKLocalSearch.Request()
    searchRequest.naturalLanguageQuery = searchText
    searchRequest.resultTypes = [.pointOfInterest, .address]
    
    if let userLocation = locationManager.location?.coordinate {
      searchRequest.region = MKCoordinateRegion(
        center: userLocation,
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
      )
    }
    
    do {
      let search = MKLocalSearch(request: searchRequest)
      let response = try await search.start()
      
      for item in response.mapItems {
        let name = item.name ?? "No given name"
        let address = item.placemark.title ?? "no address"
        searchResults.append((name, address, item.placemark.coordinate))
      }
    } catch {
      print("Error searching for location: \(error.localizedDescription)")
    }
    
    return searchResults
  }
}

struct SelectedLocation {
  let address: String
  let coordinate: CLLocationCoordinate2D
}

struct LocationPicker: View {
  @StateObject private var mapSearch = MapSearch()
  @Binding var selectedLocation: SelectedLocation?
  @Binding var showLocationPicker: Bool
  
  var body: some View {
    List {
      Section {
        Text("Search for your events location")
        TextField("Search", text: $mapSearch.searchText)
          .autocorrectionDisabled()
          .textInputAutocapitalization(.never)
          .onChange(of: mapSearch.searchText) {
            mapSearch.search()
          }
        
        ForEach(mapSearch.searchResults) { result in
          Button {
            selectedLocation = SelectedLocation(
              address: result.address,
              coordinate: result.coordinate
            )
            showLocationPicker = false
          } label: {
            VStack(alignment: .leading, spacing: 4) {
              Text(result.name)
                .font(.body)
              Text(result.address)
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(.vertical, 4)
          }
        }
      }
      
      Section {
        if let location = selectedLocation {
          TextField("Address", text: .constant(location.address))
            .disabled(true)
        }
      }
    }
  }
}



#Preview {
  LocationPicker(selectedLocation: .constant(nil), showLocationPicker: .constant(true))
}
