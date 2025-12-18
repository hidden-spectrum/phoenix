//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("AnalyticsElementType Tests")
struct AnalyticsElementTypeTests {
    
    @Test("Initialize works correctly")
    func testInit() {
        let element = AnalyticsElementType("button")
        #expect(element.rawValue == "button")
        #expect(element.analyticsSupportedValue as? String == "button")
    }
    
    @Test("Static type values are correct")
    func testStaticTypes() {
        #expect(AnalyticsElementType.button.rawValue == "button")
        #expect(AnalyticsElementType.number.rawValue == "number")
        #expect(AnalyticsElementType.tab.rawValue == "tab")
        #expect(AnalyticsElementType.text.rawValue == "text")
        #expect(AnalyticsElementType.toggle.rawValue == "toggle")
    }
}
