//
//  CheckIn.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/13/26.
//

import Foundation

struct CheckIn: Identifiable, Codable {
    let id: UUID
    let latitude: Double
    let longitude: Double
    let timeStamp: Date
    let cityName: String
    
    init(latitude: Double, longitude: Double, timeStamp: Date, cityName: String) {
        self.id = UUID()
        self.latitude = latitude
        self.longitude = longitude
        self.timeStamp = timeStamp
        self.cityName = cityName
    }
}
