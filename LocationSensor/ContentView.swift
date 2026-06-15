//
//  ContentView.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/13/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: LocationViewModel = LocationViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                Text("Nearby-log").font(.title)
                if viewModel.CurrentViewState == .needPermission{
                    PermissionView(onEnable: {viewModel.enableLocationButton()
                    })
                }else if viewModel.CurrentViewState == .loading{
                    loadingView()
                }else if viewModel.CurrentViewState == .ready{
                    LocationReadyView(
                        latText: viewModel.latitude,
                        lonText: viewModel.longitude,
                        onRefresh: {viewModel.refreshButton()},
                        onSave: {viewModel.saveCheckInButtonTapped()}
                    )
                }else if viewModel.CurrentViewState == .failed{
                    failedView(
                        message: viewModel.errorMessage,
                        onTryAgain: {viewModel.enableLocationButton()}
                    )
                }
                Divider()
                
                    .padding()
                checkInListView(
                    checkIn: viewModel.checkIns,
                    onClearAll: {viewModel.clearAll()}
                )
            }
        }
    }
    
    struct checkInListView:View{
        let checkIn: [CheckIn]
        let onClearAll: () -> Void
        
        var body: some View{
            
            VStack{
                Text("Check ins")
                
                Button("Clear all"){
                    onClearAll()
                }.disabled(checkIn.count == 0)
                
                if checkIn.count == 0{
                    Text("No check in")
                }else {
                    List(checkIn){item in
                        VStack{
                            Text(item.timeStamp, style: .date)
                            Text("Time Stamp: \(item.timeStamp, style: .time)")

                            Text("Latitude: \(String(format:"%.5f", item.latitude))")
                            Text("Langitude: \(String(format:"%.5f", item.longitude))")
                            HStack{
                                Image(systemName: "pin.fill")
                                Text("City: \(item.cityName)")
                                    .font(.title2)
                            }
                            .padding()
                            .foregroundStyle(.mint).bold()
                            NavigationLink(destination: WeatherView(targetCity: item.cityName)){
                                    HStack{
                                    Image(systemName: "sun.haze")
                                    Text("View Weather")
                                }
                            }
                            .padding()
                            .foregroundStyle(.white)
                            .bold()
                            .background(.blue.opacity(0.6))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                
                
            }
            
        }
    }
    
    
    struct failedView:View{
        let message:String
        let onTryAgain:() -> Void
        
        var body: some View{
            VStack{
                Text(message).foregroundStyle(.red)
                Button("Try again"){
                    onTryAgain()
                }
            }
        }
    }
    
    struct loadingView:View{
        var body: some View{
            VStack{
                ProgressView()
                Text("Getting your location")
            }
        }
    }
    

}

#Preview {
    ContentView()
}
