//
//  CountryService.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import Foundation
import Combine

// MARK: - Service
class CountryService {
    
    var bag: Set<AnyCancellable> = Set()
    
    func fetchCountries(completion: @escaping ([CountryList])-> Void) {
        // JSON Parsing
        func mapToCountries(json: Any)throws-> [CountryList] {
            guard let arrayDictionary = json as? [NSDictionary] else {
                throw APIError.parsingError
            }
            var countries: [CountryList] = []
            for dictionary in arrayDictionary {
                countries.append(CountryList(dictionary: dictionary))
            }
            return countries
        }
        // API Call
        guard let url = URL(string: "https://restcountries.com/v3.1/all?fields=name,flags,latlng") else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(validateHTTPURLResponse)
            .tryMap(mapToJSON)
            .tryMap(mapToCountries)
            .receive(on: RunLoop.main)
            .sink { completion in
                Log.apiResponse("API completed: \(completion)")
            } receiveValue: { countries in
                completion(countries)
            }
            .store(in: &bag)
    }
    
    func fetchCountryDetail(name: String, completion: @escaping (CountryDetail)-> Void) {
        // JSON Parsing
        func mapToCountryDetail(json: Any)throws-> CountryDetail {
            guard let arrayDictionary = json as? [NSDictionary],
                  let firstDictionary = arrayDictionary.first else {
                throw APIError.parsingError
            }
            let countryDetail = CountryDetail(dictionary: firstDictionary)
            countryDetail.logPropertiesWithValue()
            return countryDetail
        }
        // API Call
        guard let url = URL(string: "https://restcountries.com/v3.1/name/\(name)") else {
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(validateHTTPURLResponse)
            .tryMap(mapToJSON)
            .tryMap(mapToCountryDetail)
            .receive(on: RunLoop.main)
            .sink { completion in
                Log.apiResponse("API completed: \(completion)")
            } receiveValue: { countries in
                completion(countries)
                //Log.info(countries)
            }
            .store(in: &bag)
    }
}

// MARK: - Common method(s)
extension CountryService {
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
}
