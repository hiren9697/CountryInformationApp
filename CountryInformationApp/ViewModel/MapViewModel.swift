//
//  MapViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import SwiftUI
import MapKit

// MARK: - Item VM
struct MapItemViewModel: Identifiable {
    let id = UUID().uuidString
    let coordinate: CLLocationCoordinate2D
    let flagURL: URL?
    
    init(country: CountryList) {
        coordinate = country.coordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        flagURL = country.flagURL
    }
}

// MARK: - Map VM
class MapViewModel: ObservableObject {
    @Published var countries: [CountryList] = []
    @Published var itemVMs: [MapItemViewModel] = []
    var appState: AppState!
    let service = CountryService()
    
    func setup(appState: AppState) {
        self.appState = appState
    }
}

// MARK: - Web Service
extension MapViewModel {
    
    func fetchCountries() {
        appState.isLoading = true
        service.fetchCountries(completion: {[weak self] countries in
            self?.appState.isLoading = false
            self?.countries = countries
            self?.itemVMs = countries.map { MapItemViewModel(country: $0) }
        })
    }
}

