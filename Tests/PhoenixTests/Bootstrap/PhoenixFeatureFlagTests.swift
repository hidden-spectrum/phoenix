//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("Phoenix Feature Flag Tests")
struct PhoenixFeatureFlagTests {

    private struct Configuration: Decodable, Equatable, Sendable {
        let title: String
        let maximumItems: Int
    }

    private struct DirectValue: Equatable, Sendable {
        let title: String
    }

    @Test("Payload types do not require Decodable conformance")
    func directPayload() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        let flag = AnalyticsFeatureFlag<DirectValue>("direct")
        let expected = DirectValue(title: "Welcome")
        provider.setFeatureFlagValue(expected, for: flag)

        #expect(phoenix.featureFlagValue(flag) == expected)
        #expect(Phoenix.stub().featureFlagValue(flag) == nil)
    }

    @Test("Payload type is inferred from the flag and forwarded through the provider")
    func typedPayload() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        let flag = AnalyticsFeatureFlag<Configuration>("checkout")
        let configuration = Configuration(title: "Checkout", maximumItems: 5)
        provider.setFeatureFlagValue(configuration, for: flag)

        let value = phoenix.featureFlagValue(flag)

        #expect(value == configuration)
        #expect(value?.maximumItems == 5)
    }

    @Test("Named flags infer their payload type without a return type annotation")
    func namedPayload() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        provider.setFeatureFlagValue(5, for: .testItemLimit)

        let value = phoenix.featureFlagValue(.testItemLimit)

        #expect(value == 5)
    }

    @Test("Missing and removed payloads return nil")
    func missingPayload() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        let flag = AnalyticsFeatureFlag<Int>("limit")
        #expect(phoenix.featureFlagValue(flag) == nil)

        provider.setFeatureFlagValue(10, for: flag)
        #expect(phoenix.featureFlagValue(flag) == 10)

        provider.setFeatureFlagValue(nil, for: flag)
        #expect(phoenix.featureFlagValue(flag) == nil)
    }

    @Test("Payload lookup keeps keys and declared types separate")
    func mismatchedPayload() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        provider.setFeatureFlagValue(10, for: AnalyticsFeatureFlag<Int>("limit"))

        #expect(phoenix.featureFlagValue(AnalyticsFeatureFlag<String>("limit")) == nil)
        #expect(phoenix.featureFlagValue(AnalyticsFeatureFlag<Int>("other_limit")) == nil)
    }

    @Test("Boolean payloads are independent of enabled state")
    func booleanPayload() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        let flag = AnalyticsFeatureFlag<Bool>("enabled_payload")
        provider.setFeatureFlagValue(true, for: flag)

        #expect(phoenix.featureFlagValue(flag) == true)
        #expect(!phoenix.featureEnabled(flag))
    }

    @Test("Providers without feature flag support use safe defaults")
    func unsupportedProvider() {
        let phoenix = Phoenix.stub()
        let flag = AnalyticsFeatureFlag<Configuration>("checkout")

        #expect(phoenix.featureFlagValue(flag) == nil)
        #expect(!phoenix.featureEnabled(flag))
    }
}

private extension AnalyticsFeatureFlag where Value == Int {
    static var testItemLimit: Self {
        Feature("item_limit")
    }
}
