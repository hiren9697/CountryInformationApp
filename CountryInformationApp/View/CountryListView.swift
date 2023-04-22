//
//  CountryListView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import SwiftUI

struct CountryListView: View {
    
    @EnvironmentObject var appState: AppState
    var viewModel: CountryListViewModel = CountryListViewModel()
    
    var body: some View {
        NavigationStack(root: {
            List {
                ForEach(0 ..< 20,
                        content: { index in
                    CountryListItemView()
                })
            }
            .listStyle(.plain)
            .onAppear(perform: {
                viewModel.setup(appState: appState)
                viewModel.fetchData()
            })
        })
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
