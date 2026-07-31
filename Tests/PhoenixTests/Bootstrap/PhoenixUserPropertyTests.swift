//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("Phoenix User Property Tests")
struct PhoenixUserPropertyTests {

    @Test("Setting user ID forwards cached user properties")
    func testSettingUserIdForwardsCachedUserProperties() {
        let provider = TestingAnalyticsProvider()
        let phoenix = Phoenix(provider: provider)
        phoenix.setUserProperty(.contentType, to: "article")
        provider.removeAllTrackedInfo()

        phoenix.setUserId("user-id")

        #expect(provider.findSetValue(for: .contentType) as? String == "article")
    }
}
