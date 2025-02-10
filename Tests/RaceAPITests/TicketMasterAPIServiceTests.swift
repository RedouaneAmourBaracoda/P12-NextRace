//
//  TicketMasterAPIServiceTests.swift
//  NextRaceTests
//
//  Created by Redouane on 02/02/2025.
//

import XCTest
@testable import NextRace

final class TicketMasterAPIServiceTests: XCTestCase {

    var raceAPIService: TicketMasterAPIService!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let sessionMock = URLSession(configuration: configuration)
        raceAPIService = .init(session: sessionMock)
    }

    func testNetworkCallFailsWhenStatusCodeIs400() async throws {
        try await testTicketMasterAPIError(statusCode: 400, testedError: .badRequest)
    }

    func testNetworkCallFailsWhenStatusCodeIs401() async throws {
        try await testTicketMasterAPIError(statusCode: 401, testedError: .unauthorized)
    }

    func testNetworkCallFailsWhenStatusCodeIs404() async throws {
        try await testTicketMasterAPIError(statusCode: 404, testedError: .notFound)
    }

    func testNetworkCallFailsWhenStatusCodeIs429() async throws {
        try await testTicketMasterAPIError(statusCode: 429, testedError: .tooManyRequests)
    }

    func testNetworkCallFailsWhenStatusCodeIs5XX() async throws {
        try await testTicketMasterAPIError(statusCode: Int.random(in: 500...599), testedError: .internalError)
    }

    func testNetworkCallFailsWhenStatusCodeIsUnknown() async throws {
        try await testTicketMasterAPIError(
            statusCode: Set(-1000...1000)
                .subtracting(Set([200, 400, 401, 403, 404, 429]))
                .subtracting(Set(500...599))
                .randomElement() ?? 0,
            testedError: .invalidRequest
        )
    }

    // swiftlint:disable line_length
    // swiftlint:disable:next function_body_length
    func testNetworkCallSuccess() async throws {

        // When.

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = Data("""
                {
                    "_embedded": {
                        "events": [
                            {
                                "name": "NASCAR Cup Series",
                                "id": "vv177ZboGkUpUo8u",
                                "images": [
                                    {
                                        "url": "https://s1.ticketm.net/dam/a/f89/c7c11c17-4c47-4d1f-82df-a79b9b1a6f89_1262061_TABLET_LANDSCAPE_LARGE_16_9.jpg"
                                    }
                                ],
                                "dates": {
                                    "start": {
                                        "localDate": "2025-09-21",
                                    },
                                },
                                "priceRanges": [
                                    {
                                        "currency": "USD",
                                        "min": 39.0,
                                        "max": 59.0
                                    }
                                ],
                                "seatmap": {
                                    "staticUrl": "https://mapsapi.tmol.io/maps/geometry/3/event/0100611D96D9140D/staticImage?type=png&systemId=HOST",
                                },
                                "_embedded": {
                                    "venues": [
                                        {
                                            "name": "New Hampshire Motor Speedway",
                                            "id": "KovZpZAdnItA",
                                            "postalCode": "03307",
                                            "city": {
                                                "name": "Loudon"
                                            },
                                            "state": {
                                                "name": "New Hampshire",
                                                "stateCode": "NH"
                                            },
                                            "country": {
                                                "name": "United States Of America",
                                                "countryCode": "US"
                                            },
                                            "address": {
                                                "line1": "1122 Route 106 North"
                                            },
                                        }
                                    ],
                                }
                            }
                        ]
                    },
                    "page": {
                        "size": 20,
                        "totalElements": 154,
                        "totalPages": 8,
                        "number": 0
                    }
                }
                """.utf8)
            return (mockResponse, mockData)
        }

        // Then.

        do {
            let actualResult = try await raceAPIService.fetchRaces()
            let expectedResult = TicketMasterAPIResponse(
                _embedded: .init(
                    events: [
                        .init(
                            name: "NASCAR Cup Series",
                            id: "vv177ZboGkUpUo8u",
                            images: [
                                .init(
                                    url: "https://s1.ticketm.net/dam/a/f89/c7c11c17-4c47-4d1f-82df-a79b9b1a6f89_1262061_TABLET_LANDSCAPE_LARGE_16_9.jpg"
                                )
                            ],
                            dates: .init(start: .init(localDate: "2025-09-21")),
                            priceRanges: [
                                .init(
                                    currency: "USD",
                                    min: 39,
                                    max: 59
                                )
                            ],
                            seatmap: .init(
                                staticUrl: "https://mapsapi.tmol.io/maps/geometry/3/event/0100611D96D9140D/staticImage?type=png&systemId=HOST"
                            ),
                            _embedded: .init(
                                venues: [
                                    .init(
                                        name: "New Hampshire Motor Speedway",
                                        id: "KovZpZAdnItA",
                                        postalCode: "03307",
                                        city: .init(name: "Loudon"),
                                        state: .init(
                                            name: "New Hampshire",
                                            stateCode: "NH"
                                        ),
                                        country: .init(
                                            name: "United States Of America",
                                            countryCode: "US"
                                        ),
                                        address: .init(line1: "1122 Route 106 North")
                                    )
                                ]
                            )
                        )
                    ]
                ),
                page: .init(
                    size: 20,
                    totalElements: 154,
                    totalPages: 8,
                    number: 0
                )
            ).toSearchResult

            XCTAssertEqual(actualResult, expectedResult)
        } catch {
            XCTAssertNil(error)
        }
    }
    // swiftlint:enable line_length

    private func testTicketMasterAPIError(
        data: Data = Data(),
        statusCode: Int,
        testedError: TicketMasterAPIError
    ) async throws {

        MockURLProtocol.requestHandler = { request in
            XCTAssertNotNil(request.url)
            let mockResponse = HTTPURLResponse(
                url: request.url!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!

            let mockData = data
            return (mockResponse, mockData)
        }

        // Then.

        do {
            _ = try await raceAPIService.fetchRaces()
        } catch let error as TicketMasterAPIError {
            XCTAssertTrue(error == testedError)
            XCTAssertEqual(error.errorDescription, testedError.errorDescription)
            XCTAssertEqual(error.userFriendlyDescription, testedError.userFriendlyDescription)
        }
    }
}
