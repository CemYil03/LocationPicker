//
//  File.swift
//  
//
//  Created by Cem Yilmaz on 12.02.21.
//

import SwiftUI
import MapKit

@available(iOS 14.0, *)
public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published public var userLocation: CLLocationCoordinate2D?
    
    @Published public var currentMapRegion: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )
    
    private var locationManager: CLLocationManager = CLLocationManager()
    
    @Published public var authorizationStatus: CLAuthorizationStatus
    
    public override init() {
        
        self.authorizationStatus = locationManager.authorizationStatus
        super.init()
        self.locationManager.delegate = self

    }
    
    public func getUserLocation() -> CLLocationCoordinate2D? {
        return self.locationManager.location?.coordinate
    }
    
    public func requestAlwaysAuthorization() {
        self.locationManager.requestAlwaysAuthorization()
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus
    }
    
    public func setMapRegion(coordinate: CLLocationCoordinate2D) {
        
        withAnimation {
            
            self.currentMapRegion = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 1000,
                longitudinalMeters: 1000
            )
                
        }
        
    }
    
    public func updateUserLocation() throws {
        
        if self.userIsLocatable() {
            self.userLocation = self.getUserLocation()
        } else {
            throw LocationError.Unlocatable
        }
        
    }
    
    public func centerMapRegionOnUserLocation() throws {
        
        do {
            
            try self.updateUserLocation()
            
            if let userLocation = self.userLocation {
                self.setMapRegion(coordinate: userLocation)
            }
            
        } catch {
            
            throw LocationError.Unlocatable
            
        }
        
    }
    
    public func userIsLocatable() -> Bool {
        return (self.locationManager.authorizationStatus == .authorizedAlways || self.locationManager.authorizationStatus == .authorizedWhenInUse)
    }
    
    public func switchToLocationSettings() {
        if let settingsULR = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsULR, options: [:], completionHandler: nil)
        }
    }
    
    enum LocationError: Error {
        case Unlocatable
    }
    
}
