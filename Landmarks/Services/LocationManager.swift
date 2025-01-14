//
//  LocationManager.swift
//  Landmarks
//
//  Created by Sofia Wong on 12/3/24.
//

import Foundation
import MapKit
//
//class LocationManager: NSObject, ObservableObject, MKLocalSearchCompleterDelegate{
//  @Published var results: [MKLocalSearchCompletion] = []
//  @Published var loca
//  
//  private var completer: MKLocalSearchCompleter
//  
//  override init() { //TODO: Define region here
//      completer = MKLocalSearchCompleter()
//      super.init()
//      completer.delegate = self
//  }
//
//  var query: String {
//      get { completer.queryFragment }
//      set { completer.queryFragment = newValue }
//  }
//  
//  func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//      results = completer.results
//  }
//  
//  func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
//          print("Error: \(error.localizedDescription)")
//      }
//  
//  func fetchLocations(for completion: MKLocalSearchCompletion) async ->
//}
