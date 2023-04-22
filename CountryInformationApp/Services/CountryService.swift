//
//  CountryService.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import Foundation
import Combine

class CountryService {
    
    var bag: Set<AnyCancellable> = Set()
    
    func fetchCountries() {
        guard let url = URL(string: "https://restcountries.com/v3.1/all") else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(validateHTTPURLResponse)
            .tryMap(mapToJSON)
            .tryMap(mapToCountries)
            .sink { completion in
                Log.apiResponse("API completed: \(completion)")
            } receiveValue: { countries in
                //Log.apiResponse("API response: \(countries)")
                for country in countries {
                    country.logPropertiesWithValue()
                }
            }
            .store(in: &bag)
    }
    
    private func validateHTTPURLResponse(data: Data, response: URLResponse)throws-> Data {
        guard let response = response as? HTTPURLResponse else {
            throw APIError.responseCastError
        }
        if response.statusCode != 200 {
            throw APIError.responseError(statusCode: response.statusCode)
        }
        return data
    }
    
    private func mapToJSON(data: Data)throws-> Any {
        let json = try JSONSerialization.jsonObject(with: data)
        return json
    }
    
    
    private func mapToCountries(json: Any)throws-> [Country] {
        guard let arrayDictionary = json as? [NSDictionary] else {
            throw APIError.parsingError
        }
        var countries: [Country] = []
        for dictionary in arrayDictionary {
            countries.append(Country(dictionary: dictionary))
        }
        return countries
    }
}
