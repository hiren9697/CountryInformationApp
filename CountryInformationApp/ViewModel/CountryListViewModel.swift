//
//  CountryListViewModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import Foundation

class CountryListViewModel {
    
    let service = CountryService()
    
    func fetchData() {
        service.fetchCountries()
    }
}
