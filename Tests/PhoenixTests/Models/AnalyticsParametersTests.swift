//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("Analytics Parameters Tests")
struct AnalyticsParametersTests {
    
    @Test("Combining with nil")
    func testCombiningWithNil() {
        let parameters: AnalyticsParameters = [.contentId: 1234]
        let combinedParameters = parameters.combining(with: nil)
        #expect(parameters == combinedParameters)
    }
    
    @Test("Combining with empty")
    func testCombiningWithEmpty() {
        let parameters: AnalyticsParameters = [.contentId: 1234]
        let emptyParameters: AnalyticsParameters = [:]
        let combinedParameters = parameters.combining(with: emptyParameters)
        #expect(parameters == combinedParameters)
    }
    
    @Test("Combining with non-empty")
    func testCombiningWithNonEmpty() {
        let parameters: AnalyticsParameters = [.elementMetricValue: 1234]
        let otherParameters: AnalyticsParameters = [.contentId: 4567]
        let combinedParameters = parameters.combining(with: otherParameters)
        #expect(combinedParameters[.elementMetricValue] != nil)
        #expect(combinedParameters[.contentId] != nil)
        #expect(combinedParameters.count == 2)
    }
    
    @Test("Mutating combine with nil")
    func testMutatingCombineWithNil() {
        var parameters: AnalyticsParameters = [.contentId: 1234]
        parameters.combine(with: nil)
        #expect(parameters[.contentId] != nil)
        #expect(parameters.count == 1)
    }
    
    @Test("Mutating combine with empty")
    func testMutatingCombineWithEmpty() {
        var parameters: AnalyticsParameters = [.contentId: 1234]
        let emptyParameters: AnalyticsParameters = [:]
        parameters.combine(with: emptyParameters)
        #expect(parameters[.contentId] != nil)
        #expect(parameters.count == 1)
    }
    
    @Test("Mutating combine with non-empty")
    func testMutatingCombineWithNonEmpty() {
        var parameters: AnalyticsParameters = [.elementValue: 1234]
        let otherParameters: AnalyticsParameters = [.contentId: 4567]
        parameters.combine(with: otherParameters)
        #expect(parameters[.elementValue] != nil)
        #expect(parameters[.contentId] != nil)
        #expect(parameters.count == 2)
    }
    
    @Test("Analytics supported value empty")
    func testAnalyticsSupportedValueEmpty() {
        let parameters: AnalyticsParameters = [:]
        let analyticsValue = parameters.analyticsSupportedValue
        let typecastDictionary = (analyticsValue as? [String: AnalyticsSupportedParameterValue]) ?? [:]
        #expect(typecastDictionary.isEmpty)
    }
    
    @Test("Analytics supported value non-empty")
    func testAnalyticsSupportedValueNonEmpty() {
        let parameters: AnalyticsParameters = [.contentId: 1234]
        let firebaseValue = parameters.analyticsSupportedValue
        let typecastDictionary = (firebaseValue as? [String: AnalyticsSupportedParameterValue]) ?? [:]
        #expect(typecastDictionary.isEmpty == false)
        #expect(typecastDictionary["content_id"] as? Int == 1234)
    }
    
    @Test("Equality with same keys and values")
    func testEqualitySameKeysAndValues() {
        let parametersOne: AnalyticsParameters = [.contentId: 1234]
        let parametersTwo: AnalyticsParameters = [.contentId: 1234]
        #expect(parametersOne == parametersTwo)
    }
    
    @Test("Equality with different keys")
    func testEqualityDifferentKeys() {
        let parametersOne: AnalyticsParameters = [.elementValue: 1234]
        let parametersTwo: AnalyticsParameters = [.contentId: 4567]
        #expect((parametersOne == parametersTwo) == false)
    }
    
    @Test("Equality with different values")
    func testEqualityDifferentValues() {
        let parametersOne: AnalyticsParameters = [.contentId: 1234]
        let parametersTwo: AnalyticsParameters = [.contentId: 4567]
        #expect((parametersOne == parametersTwo) == false)
    }
    
    @Test("Equality with one nil value")
    func testEqualityOneNilValue() {
        let parametersOne: AnalyticsParameters = [.contentId: 1234]
        let parametersTwo: AnalyticsParameters = [.contentId: nil]
        #expect((parametersOne == parametersTwo) == false)
    }
    
    @Test("Equality with both nil values")
    func testEqualityBothNilValues() {
        let parametersOne: AnalyticsParameters = [.contentId: nil]
        let parametersTwo: AnalyticsParameters = [.contentId: nil]
        #expect(parametersOne == parametersTwo)
    }
}
