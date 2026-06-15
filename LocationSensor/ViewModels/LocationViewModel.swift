//
//  LocationViewModel.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/13/26.
//

import Foundation
import Combine
import CoreLocation

enum LocationViewState{
    case needPermission
    case loading
    case ready
    case denied
    case failed
}



class LocationViewModel: ObservableObject{
    @Published var CurrentViewState: LocationViewState = .needPermission
    @Published var latitude: String = "--"
    @Published var longitude: String = "--"
    @Published var errorMessage:String = ""
    @Published var checkIns:[CheckIn] = []
    
    var locationService: LocationManager = LocationManager()
    //cancellables, set is uniqe item in array
    private var canellable: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init(){
        //observe the changes from location manager
        //publisher and subsscriber pattern, parent and child
        //publisher is locationService -> becasuse this one has the data, and it updates the data every x amount of time
        //subscriber = the one that waits for the change-> change ui or udpate Ui
        // sink means attached somthing
        self.locationService.objectWillChange.sink{ //listen for changes
            [weak self] in // it prevent memories leakage, prevent overloading, when data change run this
            DispatchQueue.main.async{ //update UI
                //here is where we update the subscriber
                if self != nil{
                    self!.upateUIFromManager() //this is my subscriber
                }
  
            }
        }
        //wait
        .store(in: &self.canellable) //save the subscription
        self.upateUIFromManager()
    }
    
    
    func upateUIFromManager(){
        if self.locationService.isLoading == true{
            self.CurrentViewState = .loading
            return
        }
        let status: CLAuthorizationStatus = self.locationService.authStatus
        
        if status == .notDetermined{
            self.CurrentViewState = .needPermission
            return
        }
        if status == .denied || status == .restricted{
            self.errorMessage = "Location access is off, enable it in settings"
            self.CurrentViewState = .denied
            return
            
        }
        if self.locationService.location != nil {
            let coordinate: CLLocationCoordinate2D = self.locationService.location!
            self.latitude = String(format:"%0.5f", coordinate.latitude)
            self.longitude = String(format:"%0.5f", coordinate.longitude)
            self.CurrentViewState = .ready
            return
        }
        self.errorMessage = "no location"
        self.CurrentViewState = .failed
    }
    func saveCheckInButtonTapped(){
        if self.locationService.location == nil{
            return
        }
        let coordinate: CLLocationCoordinate2D = self.locationService.location!
        let foundCity = self.locationService.cityName
        let newCoord: CheckIn = CheckIn(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            timeStamp: Date(),
            cityName: foundCity
        )
        
        checkIns.insert(newCoord, at:0)
    }
    
    func clearAll(){
        if self.checkIns.isEmpty{
            return
        }
        self.checkIns.removeAll()
    }
    
    func enableLocationButton(){
        errorMessage = ""
        CurrentViewState = .loading
        locationService.requestPermissionAndLocation()
    }
    
    func refreshButton(){
        errorMessage = ""
        CurrentViewState = .loading
        locationService.requestPermissionAndLocation()
    }
    
}
