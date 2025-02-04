//
//  RaceItemDetailView.swift
//  NextRace
//
//  Created by Redouane on 04/02/2025.
//

import Kingfisher
import SwiftUI

struct RaceItemDetailView: View {

    @ObservedObject private var viewModel: RaceItemDetailViewModel

    init(viewModel: RaceItemDetailViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            content()
                .customNavigationBar(navigationTitle: Localizable.raceDetailScreenNavigatioTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(Localizable.backButtonTitle).opacity(0)
                    }
                }
                .background { CustomColors.backgroundColor.ignoresSafeArea() }
        }
    }

    private func content() -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                mainImage()
                raceInfo(race: viewModel.race)
                Spacer()
            }
        }
    }

    private func mainImage() -> some View {
        cachedImage(url: viewModel.race.imageURL)
    }

    private func raceInfo(race: Race) -> some View {
        VStack(alignment: .leading) {
            HStack {
                date()
                Spacer()
                Divider()
                    .frame(width: 1)
                    .background { Color.white }
                Spacer()
                price()
            }
            .padding(.bottom)
            raceway()
            seatmap()
                .padding(.bottom)
            location()
        }
        .padding()
    }

    @ViewBuilder
    private func date() -> some View {
        if let date = viewModel.race.date {
            info(title: date.formatted(.dateTime.day().month(.wide)), subtitle: date.formatted(.dateTime.year()), systemName: "calendar")
        }
    }

    @ViewBuilder
    private func price() -> some View {
        if let price = viewModel.race.price {
            info(title: "\(price.min) - \(price.max)", subtitle: "\(price.currency)", systemName: "dollarsign.circle")
        }
    }

    private func raceway() -> some View {
        info(title: viewModel.race.name, subtitle: viewModel.race.venue.name, systemName: "road.lanes.curved.left")
    }

    @ViewBuilder
    private func seatmap() -> some View {
        if let url = viewModel.race.seatmapURL {
            cachedImage(url: url, height: 200)
        }
    }

    private func location() -> some View {
        info(title: "\(viewModel.race.venue.country)", subtitle: "\(viewModel.race.venue.city) - \(viewModel.race.venue.address) - \(viewModel.race.venue.state) - \(viewModel.race.venue.postalCode)", systemName: "location")
    }

    private func info(title: String, subtitle: String, systemName: String) -> some View {
        HStack {
            resizableImage(systemName: systemName)
            VStack(alignment: .leading) {
                Text(title)
                    .font(.custom(CustomFonts.body, size: 20))
                Text(subtitle)
                    .font(.custom(CustomFonts.body, size: 15))
            }
            .foregroundStyle(Color.white)
        }
    }

    private func resizableImage(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 20.0)
            .padding(.trailing)
    }

    @MainActor
    private func cachedImage(url: String, height: CGFloat = 300.0) -> some View {
        KFImage(URL(string: url))
            .placeholder {
                ProgressView().progressViewStyle(.circular)
            }
            .onFailureImage(KFCrossPlatformImage(systemName: "xmark.circle"))
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(maxHeight: height)
            .clipShape(.rect(cornerRadius: 1.0))
    }
}

private extension Localizable {
    static let raceDetailScreenNavigatioTitle = NSLocalizedString(
        "race-detail.navigation-title",
        comment: ""
    )
}

#Preview {
    RaceItemDetailView(viewModel: .init(race: .nascarXfinitySeries))
}
