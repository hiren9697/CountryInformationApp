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
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = MapViewModel()
    
    var body: some View {
        VStack {
            if viewModel.countries.isEmpty {
                EmptyView()
            } else {
                Map(coordinateRegion: $region,
                    annotationItems: viewModel.itemVMs,
                    annotationContent: { item in
                    MapAnnotation(coordinate: item.coordinate,
                                  content: {
                        CountryMarkerView(viewModel: item)
                    })
                })
            }
        }
        .onAppear(perform: {
            viewModel.setup(appState: appState)
            viewModel.fetchCountries()
        })
    }
}

// MARK: - Preview
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
