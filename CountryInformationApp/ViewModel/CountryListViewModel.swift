//
//  CountryListViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import Foundation
import Combine

enum DataLoadNetworkServiceStatus {
    case notAttempted
    case finishedWithError
    case finishedWithSuccess
}

class CountryListViewModel: ObservableObject {
    
    var appState: AppState!
    let service = CountryService()
    var bag: Set<AnyCancellable> = Set()
    @Published var countries: [CountryList] = []
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    func fetchData() {
        appState.isLoading = true
        service.fetchCountries(completion: {[weak self] countries in
                guard let strongSelf = self else { return }
                strongSelf.appState.isLoading = false
                strongSelf.countries = countries
                strongSelf.dataLoadStatus = .finishedWithSuccess
        })
    }
}
