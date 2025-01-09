//
//  MockData.swift
//  Landmarks
//
//  Created by Sofia Wong on 1/9/25.
//

import Foundation
import CoreLocation

let mockActivities: [Act] = [
    Act(
        activity_id: "070C723B-5211-4668-8700-B1FB80B3959D",
        name: "Testing Location",
        location_description: nil,
        description: "The rock",
        category: "Sport",
        participants: 0,
        is_private: false,
        is_recurring: false,
        participants_list: [],
        address: "The Rock, GA, United States",
        coordinates: Act.Coordinates(
            latitude: 32.9638904,
            longitude: -84.24111859999999
        )
    ),
    Act(
        activity_id: "4E5D660A-5E97-423B-A83E-A1F5245CFB1A",
        name: "Pickleball",
        location_description: nil,
        description: "Beginner level pickleball",
        category: "Pickleball",
        participants: 1,
        is_private: false,
        is_recurring: false,
        participants_list: ["IxoYhgJc6hhQ1CqKJZxntUE98Yn2"],
        address: "Piedmont Park (Active Oval)",
        coordinates: Act.Coordinates(
            latitude: 33.7844,  // Example coordinates for Piedmont Park
            longitude: -84.3733
        )
    ),
    Act(
        activity_id: "E330F52C-26CC-4D38-86AB-9ABF70339319",
        name: "Test 2 in range",
        location_description: "",
        description: "In range of map to see marker",
        category: "Soccer",
        participants: 1,
        is_private: false,
        is_recurring: false,
        participants_list: [],
        address: "850 Bush St, San Francisco, CA  94108, United States",
        coordinates: Act.Coordinates(
            latitude: 37.7899727,
            longitude: -122.4113488
        )
    )
]
