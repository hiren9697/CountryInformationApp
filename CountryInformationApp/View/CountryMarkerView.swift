//
//  CountryMarkerView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

// MARK: - View
struct CountryMarkerView: View {
    
    let viewModel: MapItemViewModel
    
    var body: some View {
        WebImage(url: viewModel.flagURL)
            .resizable()
            .scaledToFill()
            .frame(width: 30, height: 22)
            .clipShape(RoundedRectangle(cornerRadius: 4))
            
    }
}

// MARK: - Preview
struct CountryMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        let countryList = CountryList(name: "Hong Kong",
                                      flagURLString: "https://flagcdn.com/w320/hk.png",
                                      coordinates: CLLocationCoordinate2D(latitude: 22.267,
                                                                          longitude: 114.188))
        CountryMarkerView(viewModel: MapItemViewModel(country: countryList))
    }
}
