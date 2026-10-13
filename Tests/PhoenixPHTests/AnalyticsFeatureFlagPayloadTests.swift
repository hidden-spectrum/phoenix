//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

@testable import PhoenixPH

import Foundation
import Testing


@Suite("PostHog Feature Flag Payload Tests")
struct AnalyticsFeatureFlagPayloadTests {

    private struct Configuration: Decodable, Equatable, Sendable {
        let title: String
        let limits: [Int]
    }

    private enum Mode: String, Decodable, Sendable {
        case compact
    }

    @Test("JSON objects decode into custom configuration types")
    func objectPayload() {
        let flag = AnalyticsFeatureFlag<Configuration>("configuration")
        let payload: [String: Any] = ["title": "Checkout", "limits": [1, 5, 10]]

        #expect(flag.decodePayload(payload) == Configuration(title: "Checkout", limits: [1, 5, 10]))
    }

    @Test("Top-level scalar, array, and enum payloads decode")
    func scalarAndArrayPayloads() {
        #expect(AnalyticsFeatureFlag<String>("title").decodePayload("Checkout") == "Checkout")
        #expect(AnalyticsFeatureFlag<Int>("limit").decodePayload(5) == 5)
        #expect(AnalyticsFeatureFlag<Double>("ratio").decodePayload(0.5) == 0.5)
        #expect(AnalyticsFeatureFlag<Bool>("toggle").decodePayload(false) == false)
        #expect(AnalyticsFeatureFlag<[Int]>("limits").decodePayload([1, 5]) == [1, 5])
        #expect(AnalyticsFeatureFlag<Mode>("mode").decodePayload("compact") == .compact)
    }

    @Test("Missing, null, and malformed payloads return nil")
    func invalidPayloads() {
        let flag = AnalyticsFeatureFlag<Configuration>("configuration")

        #expect(flag.decodePayload(nil) == nil)
        #expect(flag.decodePayload(NSNull()) == nil)
        #expect(flag.decodePayload(["title": "Checkout"]) == nil)
        #expect(flag.decodePayload(["title": 5, "limits": [1]]) == nil)
        #expect(flag.decodePayload("not a configuration") == nil)
        #expect(AnalyticsFeatureFlag<Mode>("mode").decodePayload("unknown") == nil)
    }

    @Test("JSON scalar types are not coerced into unrelated types")
    func mismatchedScalarTypes() {
        #expect(AnalyticsFeatureFlag<Bool>("toggle").decodePayload(1) == nil)
        #expect(AnalyticsFeatureFlag<Int>("limit").decodePayload(true) == nil)
        #expect(AnalyticsFeatureFlag<Int>("limit").decodePayload("5") == nil)
    }
}
