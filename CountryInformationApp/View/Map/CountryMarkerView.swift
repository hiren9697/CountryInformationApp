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
    
    let country: CountryList
    let onTapAction: VoidCallback
    
    var body: some View {
        VStack(spacing: -2) {
            WebImage(url: country.flagURL)
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 22)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(3)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                )
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10))
        }
        .onTapGesture(perform: onTapAction)
    }
}

// MARK: - Preview
struct CountryMarkerView_Previews: PreviewProvider {
    static var previews: some View {
        let countryList = CountryList(name: "Hong Kong",
                                      flagURLString: "https://flagcdn.com/w320/hk.png",
                                      coordinates: CLLocationCoordinate2D(latitude: 22.267,
                                                                          longitude: 114.188))
        CountryMarkerView(country: countryList ,
                          onTapAction: {})
    }
}
