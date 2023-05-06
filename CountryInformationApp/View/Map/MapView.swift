//
//  MapView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import SwiftUI
import MapKit

// MARK: - MapView
struct MapView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        NavigationStack(root: {
            VStack {
                if viewModel.countries.isEmpty {
                    EmptyView()
                } else {
                    mapContentView
                }
            }
            .navigationDestination(for: CountryList.self,
                                   destination: { country in
                CountryDetailView(viewModel: CountryDetailViewModel(countryName: country.name))
            })
        })
        .onAppear(perform: {
            viewModel.setup(appState: appState)
            viewModel.fetchCountries()
        })
    }
}

// MARK: - UI Components
extension MapView {
    
    private var mapContentView: some View {
        ZStack(alignment: .bottom) {
            // 1. Map
            Map(coordinateRegion: $viewModel.region,
                annotationItems: viewModel.countries,
                annotationContent: { country in
                MapAnnotation(coordinate: country.coordinates,
                              content: {
                    CountryMarkerView(country: country,
                                      isSelected: viewModel.selectedCountry == country,
                                      onTapAction: {
                        withAnimation {
                            viewModel.selectedCountry = country
                        }
                    })
                        .scaleEffect(country == viewModel.selectedCountry ? 2 : 1)
                        .animation(.default,
                                   value: country == viewModel.selectedCountry ? 2 : 1)
                })
            })
            VStack {
                // 2. Search
                MapSearchView(searchedCountries: $viewModel.searchedCountries,
                              searchText: $viewModel.searchText,
                              onSelect: { country in
                    withAnimation {
                        viewModel.selectedCountry = country
                    }
                })
                Spacer()
                // 3. Selected country view
                if let selectedCountry = viewModel.selectedCountry {
                    NavigationLink(value: selectedCountry,
                                   label: {
                        SelectedCountryInformationView(country: selectedCountry,
                                                       onCloseTap: {
                            withAnimation {
                                viewModel.selectedCountry = nil
                            }
                        })
                    })
                }
            }
        }
    }
}

// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(AppState())
    }
}
