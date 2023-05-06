//
//  MapViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import SwiftUI
import MapKit

// MARK: - Map VM
class MapViewModel: ObservableObject {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 23,
                                                                               longitude: 72),
                                                span: MKCoordinateSpan(latitudeDelta: 20,
                                                                       longitudeDelta: 20))
    @Published var searchText: String = "" {
        didSet {
            updateSearchedCountries()
        }
    }
    @Published var selectedCountry: CountryList? {
        didSet {
            updateMapRegion()
        }
    }
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
    @Published var countries: [CountryList] = []
    @Published var searchedCountries: [CountryList] = []
    var appState: AppState!
    let service = CountryService()
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    deinit {
        Log.deallocate("Deallocated: \(String(describing: self))")
    }
}

// MARK: - Helper method(s)
extension MapViewModel {
    
    private func updateSearchedCountries() {
        let trimmedString = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty {
            searchedCountries = []
        } else {
            let lowercasedSearchText = searchText.lowercased()
            searchedCountries = countries.filter({ $0.name.lowercased().contains(lowercasedSearchText) })
        }
    }
    
    private func updateMapRegion() {
        guard let selectedCountry = selectedCountry else {
            return
        }
        let span = MKCoordinateSpan(latitudeDelta: 20,
                                    longitudeDelta: 20)
        withAnimation {
            self.region = MKCoordinateRegion(center: selectedCountry.coordinates,
                                        span: span)
        }
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

