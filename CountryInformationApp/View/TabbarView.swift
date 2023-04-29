//
//  TabView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 29/04/23.
//

import SwiftUI

// MARK: - TabView
struct TabbarView: View {
    var body: some View {
        TabView(content: {
            CountryListView()
                .tabItem({
                    Label("List", systemImage: "list.bullet")
                })
            MapView()
                .tabItem({
                    Label("Map", systemImage: "map")
                })
        })
    }
}

// MARK: - Preview
struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
