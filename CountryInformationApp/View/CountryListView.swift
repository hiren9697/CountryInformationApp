//
//  CountryListView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 21/04/23.
//

import SwiftUI

struct CountryListView: View {
    
    let viewModel = CountryListViewModel()
    
    var body: some View {
        NavigationStack(root: {
            Text("Hiren")
                .font(.custom(AppFont.regular.rawValue, size: 19))
        })
    }
}

struct CountryListView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListView()
    }
}
