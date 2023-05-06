//
//  MapSearchView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 06/05/23.
//

import SwiftUI
import MapKit

// MARK: - View
struct MapSearchView: View {
    
    @Binding var searchedCountries: [CountryList]
    @Binding var searchText: String
    @FocusState var isFocused: Bool
    let onSelect: ((CountryList)-> ())
    
    var height: CGFloat {
        let searchFieldHeight: CGFloat = 40
        let searchItemHeight: CGFloat = 40
        guard !searchedCountries.isEmpty else {
            return searchFieldHeight
        }
        let totalSearchItemHeight: CGFloat = searchItemHeight * CGFloat(searchedCountries.count)
        let limitedSearchItemHeight: CGFloat = min(260, totalSearchItemHeight)
        //print("--- Height: \(limitedSearchItemHeight + searchFieldHeight) ---")
        return limitedSearchItemHeight + searchFieldHeight
    }
    
    var body: some View {
        VStack(spacing: 0) {
            searchField
            separator
            list
        }
        .frame(height: height)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.cWhite)
                .shadow(color: AppColor.cLightGray, radius: 10, x: 0, y: 0)
        )
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
}

// MARK: - UI Components
extension MapSearchView {
    
    private var searchField: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(AppColor.cSecondaryTextColor)
            TextField("Search country",
                      text: $searchText)
            .font(Font.custom(AppFont.regular.rawValue, size: 14))
            .submitLabel(.done)
            .onSubmit {
                isFocused = false
            }
            .focused($isFocused)
            .frame(height: 40)
            if isFocused {
                Button(action: {
                    searchText = ""
                    isFocused = false
                },
                       label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(Color.gray)
                        .frame(width: 40, height: 40)
                })
            }
        }
        .padding(.leading, 10)
    }
    
    private var separator: some View {
        Rectangle()
            .fill(AppColor.cLightGray)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
    
    private var list: some View {
        List {
            ForEach(searchedCountries,
                    content: { country in
                Button(action: {
                    onSelect(country)
                    searchText = ""
                    isFocused = false
                },
                       label: {
                    MapSearchItemView(name: country.name)
                        .listRowInsets(EdgeInsets(.zero))
                })
            })
        }
        .listStyle(.plain)
        .listRowInsets(EdgeInsets(.zero))
    }
}

// MARK: - Preview
struct MapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        let countryList = CountryList(name: "Hong Kong",
                                      flagURLString: "https://flagcdn.com/w320/hk.png",
                                      coordinates: CLLocationCoordinate2D(latitude: 22.267,
                                                                          longitude: 114.188))
        MapSearchView(searchedCountries: .constant([countryList]),
                      searchText: .constant("India"),
                      onSelect: { country in })
    }
}
