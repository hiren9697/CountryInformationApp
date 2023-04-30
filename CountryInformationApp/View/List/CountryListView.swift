//
//  CountryListView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import SwiftUI

// MARK: - View
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
                        networkErrorView
                    case .finishedWithSuccess:
                        if viewModel.countries.isEmpty {
                            emptyDataView
                        } else {
                            countryListView
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

// MARK: - UI Components
extension CountryListView {
    
    private var emptyDataView: some View {
        EmptyDataView(message: "Couldn't find any country")
            .frame(maxWidth: .infinity)
            .padding(.vertical, 100)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(.zero))
    }
    
    private var networkErrorView: some View {
        NetworkErrorView()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 100)
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(.zero))
    }
    
    private var countryListView: some View {
        ForEach(viewModel.searchCountryListVMs,
                content: { vm in
            NavigationLink(value: vm,
                           label: {
                CountryListItemView(vm: vm)
            })
        })
    }
}

// MARK: - Preview
struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
