//
//  CountryListViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import Foundation
import Combine

// MARK: - List Item View Model
struct CountryListItemViewModel: Identifiable, Hashable {
    let id = UUID().uuidString
    let name: String
    let flagURL: URL?
    
    init(country: CountryList) {
        name = country.name
        flagURL = country.flagURL
    }
}

// MARK: - List View Model
class CountryListViewModel: ObservableObject {
    @Published var countries: [CountryList] = []
    @Published var countryListeItemVMs: [CountryListItemViewModel] = []
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
    @Published var searchText = ""
    var appState: AppState!
    let service = CountryService()
    var bag: Set<AnyCancellable> = Set()
    
    var searchCountryListVMs: [CountryListItemViewModel] {
        let trimmedString = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedString.isEmpty {
            return countryListeItemVMs
        } else {
            let lowercasedSearchText = searchText.lowercased()
            return countryListeItemVMs.filter({ $0.name.lowercased().contains(lowercasedSearchText) })
        }
    }
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    func fetchData() {
        appState.isLoading = true
        service.fetchCountries(completion: {[weak self] countries in
            guard let strongSelf = self else { return }
            strongSelf.appState.isLoading = false
            strongSelf.countries = countries
            strongSelf.countryListeItemVMs = strongSelf.countries.map { CountryListItemViewModel(country: $0) }
            strongSelf.dataLoadStatus = .finishedWithSuccess
        })
    }
}
