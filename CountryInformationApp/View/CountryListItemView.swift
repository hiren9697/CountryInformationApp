//
//  CountryListItemView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import SwiftUI

// MARK: - View
struct CountryListItemView: View {
    
    var body: some View {
        HStack() {
            Image(systemName: "flag")
            Text("Country name")
                .font(.custom(AppFont.regular.rawValue,
                              size: 13))
                .foregroundColor(AppColor.cPrimaryTextColor)
            Spacer()
        }
//        .listRowSeparator(.hidden)
//        .listRowInsets(EdgeInsets(.zero))
    }
}

// MARK: - Preview
struct CountryListItemView_Previews: PreviewProvider {
    static var previews: some View {
        CountryListItemView()
    }
}
