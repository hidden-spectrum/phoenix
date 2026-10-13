//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix

import Testing


@Suite("Phoenix Feature Flag Overload Tests")
struct PhoenixFeatureFlagOverloadTests {

    @Test("Decodable overload is preserved through Phoenix and the provider existential")
    func decodableOverload() {
        let provider: any AnalyticsProvider = OverloadProvider()
        let phoenix = Phoenix(provider: provider)
        let flag = AnalyticsFeatureFlag<String>("title")

        #expect(provider.featureFlagValue(flag) == "decoded")
        #expect(phoenix.featureFlagValue(flag) == "decoded")
        #expect(decodedValue(flag, from: phoenix) == "decoded")
    }

    @Test("Generic calls without a Decodable constraint use the direct overload")
    func directOverload() {
        let phoenix = Phoenix(provider: OverloadProvider())
        let flag = AnalyticsFeatureFlag<String>("title")

        #expect(directValue(flag, from: phoenix) == "direct")
    }

    private func directValue<Value>(_ flag: AnalyticsFeatureFlag<Value>, from phoenix: Phoenix) -> Value? {
        phoenix.featureFlagValue(flag)
    }

    private func decodedValue<Value: Decodable>(_ flag: AnalyticsFeatureFlag<Value>, from phoenix: Phoenix) -> Value? {
        phoenix.featureFlagValue(flag)
    }
}

private struct OverloadProvider: AnalyticsProvider {
    func setup() {}
    func setUserId(_ userId: String?) {}
    func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?) {}
    func setUserProperties(_ properties: AnalyticsParameters) {}
    func registerGlobalProperties(_ properties: AnalyticsParameters) {}
    func unregisterGlobalProperty(_ property: AnalyticsParameter) {}
    func logScreenView(_ screen: AnalyticsScreen, class screenClass: String?, parameters: AnalyticsParameters?) {}
    func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {}
    func log(_ level: AnalyticsLogLevel, message: String, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {}

    func featureFlagValue<Value>(_ feature: AnalyticsFeatureFlag<Value>) -> Value? {
        "direct" as? Value
    }

    func featureFlagValue<Value: Decodable>(_ feature: AnalyticsFeatureFlag<Value>) -> Value? {
        "decoded" as? Value
    }
}
