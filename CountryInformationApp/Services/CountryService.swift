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
    var countries: [CountryList]?
    
    func fetchCountries(completion: @escaping (Result<[CountryList], Error>)-> Void) {
        // JSON Parsing
        func mapToCountries(json: Any)throws-> [CountryList] {
            guard let arrayDictionary = json as? [NSDictionary] else {
                throw APIError.parsingError
            }
            var countries: [CountryList] = []
            for dictionary in arrayDictionary {
                if let country = CountryList(dictionary: dictionary) {
                    countries.append(country)
                }
            }
            return countries
        }
        
        // Check if countries has already been fetched
        // if so return cached countries and return
        if let countries = countries {
            completion(.success(countries))
            return
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
            .sink { result in
                switch result {
                case .finished:
                    Log.apiRequest("Fetch country detail finished successfully")
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { countries in
                self.countries = countries
                completion(.success(countries))
            }
            .store(in: &bag)
    }
    
    func fetchCountryDetail(name: String,
                            completion: @escaping (Result<CountryDetail, Error>)-> Void) {
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
        let urlString = "https://restcountries.com/v3.1/name/\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        // API Call
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.incorrectURL))
            return
        }
        logRequest(urlString: url.absoluteString, parameters: nil)
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap(validateHTTPURLResponse)
            .tryMap(mapToJSON)
            .tryMap(mapToCountryDetail)
            .receive(on: RunLoop.main)
            .sink { result in
                switch result {
                case .finished:
                    Log.apiRequest("Fetch country detail finished successfully")
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { countries in
                completion(.success(countries))
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
    
    private func logRequest(urlString: String, parameters: [String: Any]?) {
        Log.apiRequest("URL: \(urlString),\n Parameterns: \(String(describing: parameters))")
    }
}
