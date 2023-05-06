//
//  MapSearchItemView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 06/05/23.
//

import SwiftUI

// MARK: - View
struct MapSearchItemView: View {
    
    let name: String
    
    var body: some View {
        Text(name)
            .font(Font.custom(AppFont.regular.rawValue,
                              size: 14))
            .foregroundColor(AppColor.cPrimaryTextColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .frame(height: 35)
    }
}

// MARK: - Preview
struct MapSearchItemView_Previews: PreviewProvider {
    static var previews: some View {
        MapSearchItemView(name: "India")
    }
}
