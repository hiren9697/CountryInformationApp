//
//  CountryListItemView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - View
struct CountryListItemView: View {
    
    let country: CountryList
    
    var body: some View {
        HStack() {
            WebImage(url: country.flagURL)
                .resizable()
                .frame(width: 40, height: 30)
            Text(country.name)
                .font(.custom(AppFont.regular.rawValue,
                              size: 13))
                .foregroundColor(AppColor.cPrimaryTextColor)
        }
    }
}

// MARK: - Preview
//struct CountryListItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        CountryListItemView(country: CountryList(dictionary: <#T##NSDictionary#>))
//    }
//}
