//
//  LocationReadyView.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/13/26.
//

import SwiftUI

struct LocationReadyView: View {
    let latText: String
    let lonText: String
    let onRefresh:()->Void
    let onSave:()->Void
    
    var body: some View {
        VStack{
            HStack{
                Text("Latitude: \(latText)")
                Divider()
                    .frame(width: 10, height: 15)
            
                Text("Longitude: \(lonText)")
            }
                HStack{
                    Button("Refresh"){
                        self.onRefresh()
                    }
                    Button("Save"){
                        self.onSave()
                    }
                }.buttonStyle(.borderedProminent)
            
        }.padding()

    }
}





#Preview {
    LocationReadyView(latText: "12.22", lonText: "122.11",
                      onRefresh: {},
        onSave: {
            
        })
}
