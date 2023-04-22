//
//  CountryListViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import Foundation

class CountryListViewModel: ObservableObject {
    
    var appState: AppState!
    let service = CountryService()
    
    func setup(appState: AppState) {
        self.appState = appState
    }
    
    func fetchData() {
        //service.fetchCountries()
        appState.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3,
                                      execute: {
            self.appState.isLoading = false
        })
    }
}
