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
        ScrollView {
            VStack {
                switch viewModel.dataLoadStatus {
                case .notAttempted:
                    EmptyView()
                case .finishedWithError:
                    NetworkErrorView()
                case .finishedWithSuccess:
                    dataComponents
                }
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
    
    private var dataComponents: some View {
        VStack {
            header
            regionView
            languagesView
            currencyView
            Spacer()
        }
    }
    
    private var header: some View {
        
        var image: some View {
            WebImage(url: viewModel.countryDetail!.flagURL)
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(1.5, contentMode: .fill)
                .padding(.bottom, 30)
        }
        
        var nameAndPopulationView: some View {
            VStack(alignment: .leading) {
                Text(viewModel.countryDetail!.name)
                    .font(.custom(AppFont.bold.rawValue, size: 30))
                    .foregroundColor(AppColor.cPrimaryTextColor)
                HStack {
                    Text("Population")
                        .font(.custom(AppFont.regular.rawValue, size: 14))
                        .foregroundColor(AppColor.cPrimaryTextColor)
                    Text("\(viewModel.countryDetail!.population.smallFormat)")
                        .font(.custom(AppFont.regular.rawValue, size: 14))
                        .foregroundColor(AppColor.cPrimaryTextColor)
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
        var gradientView: some View {
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .padding(.bottom, 30)
        }
        
        return ZStack(alignment: .bottomLeading) {
            image
            gradientView
            nameAndPopulationView
            
        }
    }
    
    private var regionView: some View {
        HStack {
            if let capital = viewModel.countryDetail?.capital.first {
                CDRegionView(title: "Capital",
                             value: capital)
            }
            CDRegionView(title: "Region",
                         value: viewModel.countryDetail.region)
            CDRegionView(title: "Subregion",
                         value: viewModel.countryDetail.subregion)
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
                    CDGridItemView(text: viewModel.countryDetail.langugues[index])
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
                ForEach(0 ..< viewModel.countryDetail.currencies.count,
                        content: { index in
                    CDGridItemView(text: viewModel.countryDetail.currencies[index].name)
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
