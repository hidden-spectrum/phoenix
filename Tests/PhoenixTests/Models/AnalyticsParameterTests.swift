//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("AnalyticsParameter Tests")
struct AnalyticsParameterTests {
    
    @Test("Init valid with rawValue")
    func testInitWithValidRawValue() {
        let validRawValue = String(repeating: "a", count: 24)
        let property = AnalyticsParameter(validRawValue)
        #expect(property.rawValue == validRawValue)
    }
    
    @Test("Equality for equal raw values")
    func testEqualityForEqualRawValues() {
        let rawValue = "TestProperty"
        let propertyOne = AnalyticsParameter(rawValue)
        let propertyTwo = AnalyticsParameter(rawValue)
        #expect(propertyOne == propertyTwo)
    }
    
    @Test("Equality for not equal raw values")
    func testEqualityForNotEqualRawValues() {
        let propertyOne = AnalyticsParameter("PropertyOne")
        let propertyTwo = AnalyticsParameter("PropertyTwo")
        #expect(propertyOne != propertyTwo)
    }
    
    @Test("Hash value for equal raw values")
    func testHashValueForEqualRawValues() {
        let rawValue = "TestProperty"
        let propertyOne = AnalyticsParameter(rawValue)
        let propertyTwo = AnalyticsParameter(rawValue)
        #expect(propertyOne.hashValue == propertyTwo.hashValue)
    }
    
    @Test("Hash value for not equal raw values")
    func testHashValueForNotEqualRawValues() {
        let propertyOne = AnalyticsParameter("PropertyOne")
        let propertyTwo = AnalyticsParameter("PropertyTwo")
        #expect(propertyOne.hashValue != propertyTwo.hashValue)
    }
}
