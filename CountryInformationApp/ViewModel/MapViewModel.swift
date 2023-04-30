//
//  MapViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import SwiftUI
import MapKit

//// MARK: - Item VM
//struct MapItemViewModel: Identifiable, Equatable {
//    let id = UUID().uuidString
//    let coordinate: CLLocationCoordinate2D
//    let flagURL: URL?
//    let name: String
//
//    init(country: CountryList) {
//        coordinate = country.coordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
//        flagURL = country.flagURL
//        self.name = country.name
//    }
//
//    static func == (lhs: MapItemViewModel, rhs: MapItemViewModel) -> Bool {
//        lhs.id == rhs.id
//    }
//}

// MARK: - Map VM
class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23,
                                                                               longitude: 72),
                                                span: MKCoordinateSpan(latitudeDelta: 20,
                                                                       longitudeDelta: 20))
    @Published var selectedCountry: CountryList?
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
    @Published var countries: [CountryList] = []
    var appState: AppState!
    let service = CountryService()
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    deinit {
        Log.deallocate("Deallocated: \(String(describing: self))")
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
            case .failure(let error):
                Log.error("Encountered error while fetching country list: \(error.localizedDescription)")
                self?.dataLoadStatus = .finishedWithError
            }
            self?.appState.isLoading = false
        })
    }
}

