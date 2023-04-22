//
//  ContentView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var appState = AppState()
    
    var body: some View {
        ZStack {
            // 1. App Content
            CountryListView()
                .environmentObject(appState)
            // 2. Loader
            if appState.isLoading {
            LoadingView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
