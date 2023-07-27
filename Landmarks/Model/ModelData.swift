//
//  ModelData.swift
//  Landmarks
//
//  Created by Sofia Wong on 6/5/23.
//

import Foundation
import Combine

final class ModelData: ObservableObject {
    @Published var activity: [Activity] = load("landmarkData.json")//change
    var hikes: [Hike] = load("hikeData.json") //change
    @Published var profile = Profile.default
    //@Published var act: [Act] = load("landmarkData.json")//change
    
    var categories: [String: [Activity]] {
        Dictionary(
            grouping: activity,
            by: { $0.category.rawValue }
            )
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) from main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
