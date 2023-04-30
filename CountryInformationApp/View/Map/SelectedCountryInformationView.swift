//
//  SelectedCountryInformationView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 30/04/23.
//

import SwiftUI
import MapKit
import SDWebImageSwiftUI

// MARK: - View
struct SelectedCountryInformationView: View {
    
    let country: CountryList
    let onCloseTap: VoidCallback
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // 1. Content
            HStack(spacing: 14) {
                WebImage(url: country.flagURL)
                    .resizable()
                    .frame(width: 80, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(country.name)
                    .font(.custom(AppFont.bold.rawValue, size: 18))
                    .foregroundColor(AppColor.cPrimaryTextColor)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppColor.cPrimaryBackground)
            )
            // 2. Close button
            Button(action: onCloseTap,
                   label: {
                Image(systemName: "xmark.circle.fill")
                    .padding(7)
            })
        }
        .padding()
    }
}

// MARK: - Preview
struct SelectedCountryInformationView_Previews: PreviewProvider {
    static var previews: some View {
        let countryList = CountryList(name: "Hong Kong",
                                      flagURLString: "https://flagcdn.com/w320/hk.png",
                                      coordinates: CLLocationCoordinate2D(latitude: 22.267,
                                                                          longitude: 114.188))
        SelectedCountryInformationView(country: countryList,
                                       onCloseTap: {})
    }
}
