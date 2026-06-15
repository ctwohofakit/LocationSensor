//
//  WeatherModel.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/14/26.
//

import Foundation

struct GeoCodingResult: Codable{
    let name: String
    let latitude: Double
    let longitude: Double
}

//{} = OBJECT -> CUSTOM TYPE-> MODEL
struct WeatherModel: Codable{
    let results: [GeoCodingResult]?
  
}

struct ForecastResponse: Codable{
    let current_weather:CurrentWeather // key
}

struct CurrentWeather: Codable{
    let temperature: Double
    let windspeed: Double
    let weathercode: Int
    let time: String
}
