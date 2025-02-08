//
//  MockURLProtocol.swift
//  NextRaceTests
//
//  Created by Redouane on 02/02/2025.
//

import Foundation

final class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override static func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let requestHandler = MockURLProtocol.requestHandler else { return }
        do {
            let (response, data) = try requestHandler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            print(error)
        }
    }

    override func stopLoading() { }

    static func startInterceptingRequests() { URLProtocol.registerClass(MockURLProtocol.self) }

    static func stopInterceptingRequests() { URLProtocol.unregisterClass(MockURLProtocol.self) }
}
