//
//  RaceItemView.swift
//  NextRace
//
//  Created by Redouane on 03/02/2025.
//

import SwiftUI

struct RaceItemView: View {
    let item: Race
    var body: some View {
        HStack {
            dateView()
            divider()
            titleView()
            Spacer()
            chevron()
        }
        .frame(height: 100)
        .padding(.horizontal)
        .background { CustomColors.offWhite }
        .clipShape(.rect)
        .padding(.trailing)
        .padding(.vertical)
    }

    @ViewBuilder
    private func dateView() -> some View {
        if let date = item.date {
            VStack {
                Text(date, format: .dateTime.day())
                    .font(.custom(CustomFonts.body, size: 17))
                    .foregroundStyle(CustomColors.backgroundColor)
                Text(date, format: .dateTime.month())
                    .font(.custom(CustomFonts.body, size: 17))
                    .foregroundStyle((CustomColors.backgroundColor))
            }
        }
    }

    private func divider() -> some View {
        Divider()
            .frame(width: 1)
            .background { CustomColors.backgroundColor }
    }

    private func titleView() -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.name)
                .font(.custom(CustomFonts.body, size: 20.0))
                .foregroundStyle((CustomColors.backgroundColor))
            Text(item.venue.name)
                .font(.custom(CustomFonts.body, size: 15.0))
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func chevron() -> some View {
        Image("Chevron", bundle: .main)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 20.0)
            .foregroundStyle(Color.red)
    }
}

extension Race {
    static let nascarCupSeries = Race(
        id: UUID().uuidString,
        name: "NASCAR Cup Series",
        imageURL: "https://s1.ticketm.net/dam/a/f89/c7c11c17-4c47-4d1f-82df-a79b9b1a6f89_1262061_TABLET_LANDSCAPE_LARGE_16_9.jpg",
        venue: .init(
            name: "New Hampshire Motor Speedway",
            postalCode: "03307",
            city: "Loudon",
            state: "New Hampshire",
            country: "United States Of America",
            address: "1122 Route 106 North"
        ),
        date: .now,
        seatmapURL: "https://mapsapi.tmol.io/maps/geometry/3/event/0100611D96D9140D/staticImage?type=png&systemId=HOST",
        price: .init(
            currency: "USD",
            min: 39,
            max: 59
        )
    )

    static let nascarXfinitySeries = Race(
        id: UUID().uuidString,
        name: "NASCAR XFINITY Series",
        imageURL: "https://s1.ticketm.net/dam/a/8d8/f063b33c-d4fb-4a60-acdc-a043320688d8_1603971_RETINA_LANDSCAPE_16_9.jpg",
        venue: .init(
            name: "Phoenix Raceway",
            postalCode: "85323",
            city: "Avondale",
            state: "Arizona",
            country: "United States Of America",
            address: "7602 Jimmie Johnson Dr"
        ),
        date: .now,
        seatmapURL: "https://mapsapi.tmol.io/maps/geometry/3/event/19006175C8612BF6/staticImage?type=png&systemId=HOST",
        price: .init(
            currency: "USD",
            min: 105,
            max: 240
        )
    )
}

#Preview {
    ZStack {
        CustomColors.backgroundColor.ignoresSafeArea()
        RaceItemView(item: .nascarCupSeries)
    }
}
