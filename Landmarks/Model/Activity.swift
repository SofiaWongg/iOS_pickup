//
//  Activity.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/22/23.
//

import Foundation
import SwiftUI
import CoreLocation

struct Activity: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var address: String
    var description: String
    var isFavorite: Bool
    var category: Category
    enum Category: String, CaseIterable, Codable {
        case soccer = "Soccer"
        case running = "Running"
        case basketball = "Basketball"
    }
    
    private var imageName: String
    var image: Image {
        Image(imageName)
    }
    
    private var coordinates: Coordinates
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
