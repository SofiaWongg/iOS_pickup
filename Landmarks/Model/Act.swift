//
//  Act.swift
//  Landmarks
//
//  Created by Sofia Wong on 7/18/23.
//

import Foundation
import SwiftUI
import CoreLocation

//Hashable: The Hashable protocol allows a type to be hashed, which means it can be converted into a unique numerical value. Hashing is used in various operations, such as storing values in dictionaries or sets. By conforming to the Hashable protocol, a struct can provide an implementation for the hash(into:) method, which generates a hash value based on its properties. This enables the struct to be used as a key type in dictionaries or as a member of a set.
//
//Codable: The Codable protocol provides a convenient way to encode and decode instances of a struct or class from and to different representations, such as JSON or binary data. By conforming to the Codable protocol, a struct can be encoded into a serialized format (encoding) and decoded from that format back into an instance (decoding). This is particularly useful when working with network requests, file storage, or interchanging data with other systems.
//
//Conforming to Codable requires that a struct's properties are themselves Codable. If any properties are custom types, those types must also conform to Codable.
//
//Identifiable: The Identifiable protocol is used to provide a unique identifier for a struct or class. By conforming to the Identifiable protocol, a struct is required to have a property called id, which acts as a unique identifier. This is useful in scenarios where you need to identify or compare instances of a struct, such as when working with SwiftUI's list views or when managing collections of objects.
//
//The Identifiable protocol is often used in combination with other SwiftUI constructs like ForEach or List, which rely on the identifiable nature of the elements to efficiently update and render views.

struct Act: Hashable, Identifiable {
    var activity_id: String
    var name: String
    var location_description: String?
    var description: String
    var category: String
    var participants: Int
    var is_private: Bool
    var is_recurring: Bool
    var id: String {
            activity_id
        }
    var participants_list: [String]
  var address: String
  var coordinates: Coordinates
  var locationCoordinate: CLLocationCoordinate2D {
      CLLocationCoordinate2D(
          latitude: coordinates.latitude,
          longitude: coordinates.longitude
      )
  }
  
  struct Coordinates: Hashable, Codable {
      var latitude: Double
      var longitude: Double
  }
}
