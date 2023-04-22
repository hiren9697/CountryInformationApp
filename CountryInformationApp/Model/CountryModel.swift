//
//  CountryModel.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import Foundation
import CoreLocation

// MARK: - Currency
struct Currency {
    let name: String
    let symbol: String
    
    init(dictionary: NSDictionary) {
        name = dictionary.stringValue(key: "name")
        symbol = dictionary.stringValue(key: "symbol")
    }
}

// MARK: - IDD
struct IDD {
    let root: String
    let suffixes: [String]
    
    init(dictionary: NSDictionary) {
        root = dictionary.stringValue(key: "root")
        if let suffiexArray = dictionary["suffixes"] as? [String] {
            self.suffixes = suffiexArray
        } else {
            self.suffixes = []
        }
    }
}

// MARK: - Country
struct Country: Mirrorable {
    let name: String
    let independent: Bool
    let currencies: [Currency]
    let idd: IDD?
    let capital: [String]
    let region: String
    let subregion: String
    let langugues: [String]
    let coordinates: CLLocationCoordinate2D?
    let isLandlockeed: Bool
    let population: Double
    let flagURLString: String?
    let timezones: [String]
    let continents: [String]
    
    init(dictionary: NSDictionary) {
        // 1. name
        if let nameDictionary = dictionary["name"] as? NSDictionary {
            name = nameDictionary.stringValue(key: "official")
        } else {
            name = "-"
        }
        // 2. Independent
        independent = dictionary.booleanValue(key: "independent")
        // 3. Currency
        if let currencyDictionary = dictionary["currencies"] as? NSDictionary {
            var currencies: [Currency] = []
            let keys = currencyDictionary.allKeys
            for key in keys {
                currencies.append(Currency(dictionary: currencyDictionary[key] as! NSDictionary))
            }
            self.currencies = currencies
        } else {
            self.currencies = []
        }
        // 4. IDD
        if let iddDictionary = dictionary["idd"] as? NSDictionary {
            idd = IDD(dictionary: iddDictionary)
        } else {
            idd = nil
        }
        // 5. Capital
        if let capitalArray = dictionary["capital"] as? [String] {
            self.capital = capitalArray
        } else {
            self.capital = []
        }
        // 6. Region
        self.region = dictionary.stringValue(key: "region")
        // 7. Subregion
        self.subregion = dictionary.stringValue(key: "subregion")
        // 8. Language
        if let languageDictionary = dictionary["languages"] as? NSDictionary {
            let keys = languageDictionary.allKeys
            var languagues: [String] = []
            for key in keys {
                languagues.append(languageDictionary[key] as! String)
            }
            self.langugues = languagues
        } else {
            langugues = []
        }
        // 9. Coordinate
        if let coordinateArray = dictionary["latlng"] as? [Double],
           coordinateArray.count == 2 {
            let latitude = coordinateArray[0]
            let longitude = coordinateArray[1]
            self.coordinates = CLLocationCoordinate2D(latitude: latitude,
                                                      longitude: longitude)
            
        } else {
            self.coordinates = nil
        }
        // 10. Landlock
        self.isLandlockeed = dictionary.booleanValue(key: "landlocked")
        // 11. Population
        self.population = dictionary.doubleValue(key: "population")
        // 12. Flag
        if let flagDictionary = dictionary["flags"] as? NSDictionary {
            flagURLString = flagDictionary.stringValue(key: "png")
        } else {
            flagURLString = nil
        }
        // 13. Timezone
        self.timezones = dictionary["timezones"] as? [String] ?? []
        // 14. Continents
        self.continents = dictionary["continents"] as? [String] ?? []
    }
    
//    func listPropertiesWithValues(reflect: Mirror? = nil) {
//            let mirror = reflect ?? Mirror(reflecting: self)
//            if mirror.superclassMirror != nil {
//                self.listPropertiesWithValues(reflect: mirror.superclassMirror)
//            }
//
//            for (index, attr) in mirror.children.enumerated() {
//                if let property_name = attr.label {
//                    print("\(mirror.description) \(index): \(property_name) = \(attr.value)")
//                }
//            }
//        }
}
