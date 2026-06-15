//
//  WeatherViewModel.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/14/26.
//

//

import Combine
import Foundation

@MainActor
class WeatherViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    
    //data display
    @Published var cityName: String = ""
    @Published var temperatureText: String = ""
    @Published var windText: String = ""
    @Published var timeText: String = ""
    
    //help var
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    let API: APIService = APIService()
    
    func fetchWeather(forCity city: String)async{
        self.errorMessage = ""
        self.isLoading = true
        let trimmedText = city.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty || trimmedText == "Unknown" || trimmedText == ""{
            self.errorMessage = "cannot fetch weather for that location"
            self.isLoading = false
            return
            
        }
    
        do{
            let result = try await API.fetchCurrentWeather(forCity: trimmedText)
            self.cityName = result.cityName
            self.temperatureText = "\(result.weather.temperature)"
            self.windText = "\(result.weather.windspeed)"
            self.timeText = "\(result.weather.time)"
            self.isLoading = false
            
            
        }catch{
            self.errorMessage = "something went wrong"
            self.isLoading = false
        }
    }
    
}
