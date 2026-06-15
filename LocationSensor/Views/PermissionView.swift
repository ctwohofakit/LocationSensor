//
//  PermissionView.swift
//  LocationSensor
//
//  Created by Kit Sitou on 6/13/26.
//

import SwiftUI

struct PermissionView: View {
    let onEnable: () -> Void // pass in function
    
    
    var body: some View {
        VStack(spacing: 12){
            Text("We need the location to save teh check ins")
            Button("Enable location"){
                self.onEnable()
            }.buttonStyle(.borderedProminent)
        }
        
        
        
        
    }
}

#Preview {
    PermissionView(onEnable: {})
}
