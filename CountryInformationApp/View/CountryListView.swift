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
                    .navigationTitle("Countries")
            case .finishedWithError:
                Text("Something went wrong")
                    .navigationTitle("Countries")
            case .finishedWithSuccess:
                if viewModel.countries.isEmpty {
                    Text("No data found")
                        .navigationTitle("Countries")
                } else {
                    List {
                        ForEach(viewModel.searchCountryListVMs,
                                content: { vm in
                            CountryListItemView(vm: vm)
                        })
                    }
                    .listStyle(.plain)
                    .searchable(text: $viewModel.searchText, prompt: "Search country")
                    .navigationTitle("Countries")
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
