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
            case .finishedWithSuccess, .finishedWithError:
                List {
                    switch viewModel.dataLoadStatus {
                    case .finishedWithError:
                        NetworkErrorView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 100)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(.zero))
                    case .finishedWithSuccess:
                        if viewModel.countries.isEmpty {
                            EmptyDataView(message: "Couldn't find any country")
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 100)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(.zero))
                        } else {
                            ForEach(viewModel.searchCountryListVMs,
                                    content: { vm in
                                NavigationLink(value: vm,
                                               label: {
                                    CountryListItemView(vm: vm)
                                })
                            })
                        }
                    default: Text("Error")
                    }
                }
                .refreshable {
                    viewModel.fetchData(showLoader: false)
                }
                .listStyle(.plain)
                .if(!viewModel.countries.isEmpty) { view in
                    view.searchable(text: $viewModel.searchText, prompt: "Search country")
                }
                .navigationTitle("Countries")
                .navigationDestination(for: CountryListItemViewModel.self,
                                       destination: { vm in
                    CountryDetailView(viewModel: CountryDetailViewModel(countryName: vm.name))
                })
            }
        })
        .onAppear(perform: {
            viewModel.setup(appState: appState)
            viewModel.fetchData(showLoader: true)
        })
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
