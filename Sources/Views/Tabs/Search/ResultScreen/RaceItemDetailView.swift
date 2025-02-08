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
                .customNavigationBar(navigationTitle: Localizable.raceDetailScreenNavigationTitle)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Text(Localizable.backButtonTitle).opacity(0)
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.isFavorite ? viewModel.removeFromFavorites() : viewModel.addToFavorites()
                        } label: {
                            viewModel.isFavorite ? Image(systemName: "star.fill") : Image(systemName: "star")
                        }
                    }
                }
                .alert(isPresented: $viewModel.shouldPresentAlert) {
                    Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage))
                }
                .background { CustomColors.backgroundColor.ignoresSafeArea() }
                .onAppear {
                    viewModel.refreshFavoriteState()
                    Task { 
                        await viewModel.updateCalendarStatus()
                    }
                }
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

    @ViewBuilder
    private func mainImage() -> some View {
        if let url = viewModel.race.imageURL {
            cachedImage(url: url)
        }
    }

    private func raceInfo(race: Race) -> some View {
        VStack(alignment: .leading) {
            date()
            price()
            raceway()
            seatmap()
            location()
        }
        .padding()
    }

    @ViewBuilder
    private func date() -> some View {
        if let date = viewModel.race.date {
            HStack {
                resizableImage(systemName: "info.circle")
                Text(date.formatted(.dateTime.day().month(.wide).year()))
                    .font(.custom(CustomFonts.body, size: 20))
                    .foregroundStyle(Color.white)
                Spacer()
                if viewModel.isRaceScheduled {
                    resizableImage(systemName: "calendar.badge.checkmark")
                        .foregroundStyle(.green)
                } else {
                    Button {
                        Task {
                            await viewModel.addRaceToCalendar()
                        }
                    } label: {
                        Text(Localizable.scheduleButtonTitle)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.scheduleInProgress)
                }
            }
        }
    }

    @ViewBuilder
    private func price() -> some View {
        if let price = viewModel.race.price {
            HStack {
                resizableImage(systemName: "dollarsign.circle")
                if Int(price.min) == Int(price.max) {
                    Text("\(Int(price.max)) \(price.currency)")
                        .font(.custom(CustomFonts.body, size: 20))
                        .foregroundStyle(Color.white)
                } else {
                    Text("\(Int(price.min)) - \(Int(price.max)) \(price.currency)")
                        .font(.custom(CustomFonts.body, size: 20))
                        .foregroundStyle(Color.white)
                }
            }
        }
    }

    private func raceway() -> some View {
        HStack {
            resizableImage(systemName: "road.lanes.curved.left")
            Text(viewModel.race.name)
                .font(.custom(CustomFonts.body, size: 20))
                .foregroundStyle(Color.white)
        }
    }

    @ViewBuilder
    private func seatmap() -> some View {
        if let url = viewModel.race.seatmapURL {
            cachedImage(url: url, height: 250)
        }
    }

    @ViewBuilder
    private func location() -> some View {
        if let venue = viewModel.race.venue, let country = venue.country, let city = venue.city {
            HStack {
                resizableImage(systemName: "location")
                VStack(alignment: .leading) {
                    Text(country)
                        .font(.custom(CustomFonts.body, size: 20))
                        .foregroundStyle(Color.white)
                    Text(city)
                        .font(.custom(CustomFonts.body, size: 20))
                        .foregroundStyle(Color.white)
                    Text("\(venue.address ?? "") \(venue.postalCode ?? "") \(venue.state ?? "")")
                        .font(.custom(CustomFonts.body, size: 15))
                        .foregroundStyle(Color.white)
                }
            }
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
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: height)
            .clipShape(.rect(cornerRadius: 1.0))
    }
}

private extension Localizable {
    static let raceDetailScreenNavigationTitle = NSLocalizedString(
        "race-detail.navigation-title",
        comment: ""
    )
    static let scheduleButtonTitle = NSLocalizedString(
        "race-detail.schedule-button.title",
        comment: ""
    )
}

#Preview {
    RaceItemDetailView(viewModel: .init(race: .nascarXfinitySeries))
}
