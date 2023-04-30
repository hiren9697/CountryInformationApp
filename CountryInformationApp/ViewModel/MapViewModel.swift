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
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
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
        service.fetchCountries(completion: {[weak self] completion in
            switch completion {
            case .success(let countries):
                self?.dataLoadStatus = .finishedWithSuccess
                self?.countries = countries
                self?.itemVMs = countries.map { MapItemViewModel(country: $0) }
            case .failure(let error):
                Log.error("Encountered error while fetching country list: \(error.localizedDescription)")
                self?.dataLoadStatus = .finishedWithError
            }
            self?.appState.isLoading = false
        })
    }
}

