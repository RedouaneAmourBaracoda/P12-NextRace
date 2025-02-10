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
                        .accessibilityValue(
                            viewModel.isFavorite ? Localizable.favoriteButtonActivated
                            : Localizable.favoriteButtonDeactivated
                        )
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
                .accessibilityHidden(true)
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
                    .accessibilityHidden(true)
                Text(date.formatted(.dateTime.day().month(.wide).year()))
                    .font(.custom(CustomFonts.body, size: 20))
                    .foregroundStyle(Color.white)
                    .accessibilityLabel(Localizable.dateInformationAccessibilityLabel)
                    .accessibilityValue(date.description(with: .current))
                    .accessibilityHint(
                        viewModel.isRaceScheduled ?
                        Localizable.dateAddedToCalendarAccessibilityHint
                        : Localizable.dateNotAddedToCalendarAccessibilityHint
                    )
                Spacer()
                if viewModel.isRaceScheduled {
                    resizableImage(systemName: "calendar.badge.checkmark", width: 30.0)
                        .foregroundStyle(.green)
                        .accessibilityHidden(true)
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
                    .accessibilityHint(Localizable.calendarButtonAccessibilityHint)
                }
            }
        }
    }

    @ViewBuilder
    private func price() -> some View {
        if let price = viewModel.race.price {
            HStack {
                resizableImage(systemName: "dollarsign.circle")
                    .accessibilityHidden(true)
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
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Localizable.priceInformationAccessibilityLabel)
            .accessibilityValue(String(price.min) + String(price.currency))
        }
    }

    private func raceway() -> some View {
        HStack {
            resizableImage(systemName: "road.lanes.curved.left")
                .accessibilityHidden(true)
            Text(viewModel.race.name)
                .font(.custom(CustomFonts.body, size: 20))
                .foregroundStyle(Color.white)
                .accessibilityLabel(Localizable.raceDetailTitleAccessibilityLabel)
                .accessibilityValue(viewModel.race.name)
        }
    }

    @ViewBuilder
    private func seatmap() -> some View {
        if let url = viewModel.race.seatmapURL {
            cachedImage(url: url, height: 250)
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private func location() -> some View {
        if
            let venue = viewModel.race.venue,
            let country = venue.country,
            let city = venue.city,
            let address = venue.address,
            let postalCode = venue.postalCode {
            HStack {
                resizableImage(systemName: "location")
                    .accessibilityHidden(true)
                VStack(alignment: .leading) {
                    Text(country)
                        .font(.custom(CustomFonts.body, size: 20))
                        .foregroundStyle(Color.white)
                        .accessibilityLabel(Localizable.countryInformationAccessibilityLabel)
                        .accessibilityValue(country)
                    Text(city)
                        .font(.custom(CustomFonts.body, size: 20))
                        .foregroundStyle(Color.white)
                        .accessibilityLabel(Localizable.cityInformationAccessibilityLabel)
                        .accessibilityValue(city)
                    Text("\(address) \(postalCode) \(venue.state ?? "")")
                        .font(.custom(CustomFonts.body, size: 15))
                        .foregroundStyle(Color.white)
                        .accessibilityLabel(Localizable.addressInformationAccessibilityLabel)
                        .accessibilityValue(address + postalCode + (venue.state ?? ""))
                }
            }
        }
    }

    private func resizableImage(systemName: String, width: CGFloat = 20.0) -> some View {
        Image(systemName: systemName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width)
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
            .frame(maxWidth: .infinity)
            .clipShape(.rect(cornerRadius: 1.0))
    }
}

extension Localizable {
    static let raceDetailScreenNavigationTitle = NSLocalizedString(
        "race-detail.navigation-title",
        comment: ""
    )
    static let scheduleButtonTitle = NSLocalizedString(
        "race-detail.schedule-button.title",
        comment: ""
    )
    static let favoriteButtonActivated = NSLocalizedString(
        "race-detail.favorite-button.activated",
        comment: ""
    )

    static let favoriteButtonDeactivated = NSLocalizedString(
        "race-detail.favorite-button.deactivated",
        comment: ""
    )
    static let dateInformationAccessibilityLabel = NSLocalizedString(
        "race-detail.date.accessibility-label",
        comment: ""
    )
    static let dateAddedToCalendarAccessibilityHint = NSLocalizedString(
        "race-detail.date-added.accessibility-hint",
        comment: ""
    )
    static let dateNotAddedToCalendarAccessibilityHint = NSLocalizedString(
        "race-detail.date-not-added.accessibility-hint",
        comment: ""
    )
    static let calendarButtonAccessibilityHint = NSLocalizedString(
        "race-detail.calendar-button.accessibility-hint",
        comment: ""
    )
    static let priceInformationAccessibilityLabel = NSLocalizedString(
        "race-detail.price.accessibility-label",
        comment: ""
    )
    static let countryInformationAccessibilityLabel = NSLocalizedString(
        "race-detail.country.accessibility-label",
        comment: ""
    )
    static let cityInformationAccessibilityLabel = NSLocalizedString(
        "race-detail.city.accessibility-label",
        comment: ""
    )
    static let addressInformationAccessibilityLabel = NSLocalizedString(
        "race-detail.address.accessibility-label",
        comment: ""
    )
}

#Preview {
    RaceItemDetailView(viewModel: .init(race: .nascarXfinitySeries))
}
