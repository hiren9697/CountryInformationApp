//
//  CountryDetailViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import Foundation

// MARK: - VM
class CountryDetailViewModel: ObservableObject {
    
    @Published var dataLoadStatus: DataLoadNetworkServiceStatus = .notAttempted
    @Published var countryDetail: CountryDetail!
    let countryName: String
    let service = CountryService()
    var appState: AppState!
    
    init(countryName: String) {
        self.countryName = countryName
    }
    
    func setup(appState: AppState) {
        self.appState = appState
    }
}

// MARK: - Web Service
extension CountryDetailViewModel {
    
    internal func fetchCountryDetail() {
        appState.isLoading = true
        service.fetchCountryDetail(name: countryName,
                                   completion: {[weak self] result in
            switch result {
            case .success(let countryDetail):
                self?.countryDetail = countryDetail
                self?.dataLoadStatus = .finishedWithSuccess
            case .failure(let error):
                Log.error("Encountered error in fetching country detail: \(error.localizedDescription)")
                self?.dataLoadStatus = .finishedWithError
            }
            self?.appState.isLoading = false
        })
    }
}
