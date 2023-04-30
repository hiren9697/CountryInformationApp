//
//  NetworkErrorView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 30/04/23.
//

import SwiftUI

// MARK: - View
struct NetworkErrorView: View {
    
    let message: String
    
    init(message: String = "Something went wrong") {
        self.message = message
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image("ic_network_error")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            Text(message)
                .font(.custom(AppFont.medium.rawValue, size: 15))
                .foregroundColor(AppColor.cPrimaryTextColor)
                .padding(.horizontal, 10)
        }
    }
}

// MARK: - Preview
struct NetworkErrorView_Previews: PreviewProvider {
    static var previews: some View {
        NetworkErrorView(message: "Something went wrong")
    }
}
