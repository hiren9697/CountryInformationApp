//
//  CountryDetailView.swift
//  CountryInformationApp
//
//  Created by Hirenkumar Fadadu on 22/04/23.
//

import SwiftUI
import SDWebImageSwiftUI

// MARK: - View
struct CountryDetailView: View {
    
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel: CountryDetailViewModel
    
    init(viewModel: CountryDetailViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            if let _ = viewModel.countryDetail {
                header
                regionView
                languagesView
                currencyView
                Spacer()
            } else {
                EmptyView()
            }
        }
        .onAppear(perform: {
            viewModel.setup(appState: appState)
            viewModel.fetchCountryDetail()
        })
    }
}

// MARK: - UI Components
extension CountryDetailView {
    
    private var header: some View {
        HStack {
            WebImage(url: viewModel.countryDetail!.flagURL)
                .resizable()
                .frame(width: 150, height: 110)
            Spacer()
            VStack(spacing: 11) {
                Text(viewModel.countryDetail!.name)
                    .font(.custom(AppFont.bold.rawValue, size: 20))
                    .foregroundColor(AppColor.cPrimaryTextColor)
                HStack {
                    Text("Population")
                        .font(.custom(AppFont.regular.rawValue, size: 14))
                        .foregroundColor(AppColor.cSecondaryTextColor)
                    Text("\(viewModel.countryDetail!.population)")
                        .font(.custom(AppFont.regular.rawValue, size: 14))
                        .foregroundColor(AppColor.cPrimaryTextColor)
                }
                
            }
        }
        .padding()
    }
    
    private var regionView: some View {
        HStack {
            CDRegionView(title: "Capital",
                         value: viewModel.countryDetail!.capital.first!)
            CDRegionView(title: "Region",
                         value: viewModel.countryDetail!.region)
            CDRegionView(title: "Subregion",
                         value: viewModel.countryDetail!.subregion)
        }
        .padding()
    }
    
    private var languagesView: some View {
        
        HStack(spacing: 15) {
            Text("Languages")
                .font(.custom(AppFont.semibold.rawValue, size: 15))
                .foregroundColor(AppColor.cSecondaryTextColor)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10, alignment: .center),
                      GridItem(.flexible(), spacing: 10, alignment: .center),
                      GridItem(.flexible(), spacing: 10, alignment: .center)],
                      content: {
                ForEach(0 ..< viewModel.countryDetail!.langugues.count,
                        content: { index in
                    CDGridItemView(text: viewModel.countryDetail!.langugues[index])
                })
            })
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
    
    private var currencyView: some View {
        
        HStack(spacing: 15) {
            Text("Currencies")
                .font(.custom(AppFont.semibold.rawValue, size: 15))
                .foregroundColor(AppColor.cSecondaryTextColor)
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10, alignment: .center),
                      GridItem(.flexible(), spacing: 10, alignment: .center),
                      GridItem(.flexible(), spacing: 10, alignment: .center)],
                      content: {
                ForEach(0 ..< viewModel.countryDetail!.currencies.count,
                        content: { index in
                    CDGridItemView(text: viewModel.countryDetail!.currencies[index].name)
                })
            })
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

// MARK: - Reusable view
struct CDRegionView: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.cSecondaryTextColor)
            Text(value)
                .font(.custom(AppFont.regular.rawValue, size: 14))
                .foregroundColor(AppColor.cPrimaryTextColor)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColor.cSecondaryTextColor)
        )
    }
}

struct CDGridItemView: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.custom(AppFont.regular.rawValue, size: 14))
            .foregroundColor(AppColor.cSecondaryTextColor)
            .padding(.horizontal)
            //.frame(width: 200)
            .frame(height: 22)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(AppColor.cSecondaryTextColor)
            )
    }
}

// MARK: - Preview
struct CountryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CountryDetailView(viewModel: CountryDetailViewModel(countryName: "india"))
    }
}
