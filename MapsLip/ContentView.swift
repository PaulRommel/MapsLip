//
//  ContentView.swift
//  MapsLip
//
//  Created by Павел Попов on 05.11.2022.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  52.616667, longitude: 39.6), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
            .onAppear {
                viewModel.checkIfLocationServicesIsEnable()
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnable() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("Show an alert letting them know this is off and to go turn it on.")
        }
    }
    
    private func checkLocationAutorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Yuor location is restricted likely due to parental controls.")
        case .denied:
            print("Your have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            break 
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAutorization()
    }
}
