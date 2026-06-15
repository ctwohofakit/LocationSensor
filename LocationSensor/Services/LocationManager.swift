//
//  LocationManager.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/13/26.
//
import Combine
import Foundation
import CoreLocation //Location API framework


//sensor use objective C instead of swift
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    
    //the real coreloaction manager(apple API)
    private let manager: CLLocationManager = CLLocationManager()
    
    //share the location, isloading and auth status
    @Published var location:CLLocationCoordinate2D?
    @Published var isLoading:Bool = false
    
    //track current permission state
    @Published var authStatus:CLAuthorizationStatus = .notDetermined
    
    @Published var cityName: String = ""
    
    
    
    //override
    override init(){
        super.init()
        manager.delegate = self
        
        //setting for the accuracy for the sensor
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        //sets the authStatus, it shows to user of the authStatus
        authStatus = manager.authorizationStatus
    }
    
    //request location
    func requestLocation(){
        isLoading = true
        manager.requestLocation()
    }
    
    func requestPermissionAndLocation(){
        authStatus = manager.authorizationStatus
        
        if authStatus == .notDetermined{
            manager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways{
            requestLocation()
            return
        }
    }
    
    //MARK: CLLocationManagerDelegate functions
    func locationManager(_ manager:CLLocationManager, didUpdateLocations locations: [CLLocation]){
        //location =[(12,33),(11,13)]
        if let lastLocation = locations.last {
            location = lastLocation.coordinate
            Task { @MainActor in
                let geocoder = CLGeocoder()
                do{
                    let placemark = try await geocoder.reverseGeocodeLocation(lastLocation)
                    if let city = placemark.first?.locality{
                        self.cityName = city
                    }
                }catch{
                    print("Reverse geocode failed: \(error.localizedDescription)")
                    cityName = "Unknown"
                    
                }
                self.isLoading = false
            }
        }

    }

    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error){
        isLoading = false
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authStatus = manager.authorizationStatus
        
        if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways{
            requestLocation()
        }else {
            isLoading = false
        }
    }
    
    
}


