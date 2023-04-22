//
//  CountryListView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import SwiftUI

struct CountryListView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: CountryListViewModel = CountryListViewModel()
    
    var body: some View {
        NavigationStack(root: {
            switch viewModel.dataLoadStatus {
            case .notAttempted:
                EmptyView()
            case .finishedWithError:
                Text("Something went wrong")
            case .finishedWithSuccess:
                if viewModel.countries.isEmpty {
                    Text("No data found")
                } else {
                    List {
                        ForEach(viewModel.countries,
                                content: { country in
                            CountryListItemView(country: country)
                        })
                    }
                    .listStyle(.plain)
                }
            }
        })
        .onAppear(perform: {
            viewModel.setup(appState: appState)
            viewModel.fetchData()
        })
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
