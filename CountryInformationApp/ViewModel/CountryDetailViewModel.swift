//
//  CountryDetailViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import Foundation

// MARK: - VM
class CountryDetailViewModel: ObservableObject {
    
    @Published var countryDetail: CountryDetail?
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
                                   completion: {[weak self] countryDetail in
            self?.appState.isLoading = false
            self?.countryDetail = countryDetail
        })
    }
}
