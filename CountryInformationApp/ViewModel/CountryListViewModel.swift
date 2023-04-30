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
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
    @Published var countries: [CountryList] = []
    @Published var countryListeItemVMs: [CountryListItemViewModel] = []
    @Published var searchText = ""
    var appState: AppState!
    let service = CountryService()
    var bag: Set<AnyCancellable> = Set()
    
    deinit {
        Log.deallocate("Deallocated: \(String(describing: self))")
    }
    
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
    
    func fetchData(showLoader: Bool) {
        if showLoader {
            appState.isLoading = true
        }
        service.fetchCountries(completion: {[weak self] completion in
            guard let strongSelf = self else { return }
            switch completion {
            case .success(let countries):
                strongSelf.countries = countries
                strongSelf.countryListeItemVMs = strongSelf.countries.map { CountryListItemViewModel(country: $0) }
                strongSelf.dataLoadStatus = .finishedWithSuccess
            case .failure(let error):
                Log.error("Encountered error while fetching countries: \(error.localizedDescription)")
                strongSelf.dataLoadStatus = .finishedWithError
            }
            strongSelf.appState.isLoading = false
        })
    }
}
