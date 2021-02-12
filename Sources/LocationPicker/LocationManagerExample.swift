//
//  LocationManagerExample.swift
//  
//
//  Created by Cem Yilmaz on 12.02.21.
//

import SwiftUI
import MapKit

@available(iOS 14.0, *)
struct LocationManagerExample: View {
    
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {

        if let userLocation = self.locationManager.userLocation {

            ZStack {
                
                Map(coordinateRegion: self.$locationManager.currentMapRegion, showsUserLocation: true)
                    .ignoresSafeArea()
                    
                VStack {
                    
                    Spacer()
                    
                    Button("Center") {
                        
                        do {
                            try self.locationManager.centerMapRegionOnUserLocation()
                        } catch {
                            self.locationManager.switchToLocationSettings()
                        }
                        
                    }.padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(8)
                    
                }
                
            }.onAppear {
                self.locationManager.setMapRegion(coordinate: userLocation)
            }


        } else {

            if self.locationManager.authorizationStatus == .notDetermined {

                Text("").onAppear {
                    self.locationManager.requestAlwaysAuthorization()
                }

            } else if self.locationManager.userIsLocatable(), let userLocation = self.locationManager.getUserLocation() {

                Text("").onAppear {
                    self.locationManager.userLocation = userLocation
                }

            } else {

                LocationPickerView(coordinates: self.$locationManager.userLocation)
                
            }

        }
        
    }
    
}


@available(iOS 14.0, *)
struct LocationManagerExample_Previews: PreviewProvider {
    static var previews: some View {
        LocationManagerExample()
    }
}

