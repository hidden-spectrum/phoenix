//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("User Property Cache Tests")
struct UserPropertyCacheTests {

    // MARK: - Initialization Tests

    @Test("Initialization creates empty cache")
    func testInitializationCreatesEmptyCache() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentId: 1234]
        #expect(cache.hasChanges(comparedTo: parameters) == true)
    }

    // MARK: - hasChanges Tests

    @Test("hasChanges returns true when cache is empty")
    func testHasChangesReturnsTrueWhenCacheIsEmpty() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentId: 1234]
        #expect(cache.hasChanges(comparedTo: parameters) == true)
    }

    @Test("hasChanges returns false when parameters match cache")
    func testHasChangesReturnsFalseWhenParametersMatchCache() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)
    }

    @Test("hasChanges returns true when values differ")
    func testHasChangesReturnsTrueWhenValuesDiffer() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        let newParameters: AnalyticsParameters = [.contentId: 5678]
        cache.update(with: initialParameters)
        #expect(cache.hasChanges(comparedTo: newParameters) == true)
    }

    @Test("hasChanges returns true when keys differ")
    func testHasChangesReturnsTrueWhenKeysDiffer() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        let newParameters: AnalyticsParameters = [.contentType: "video"]
        cache.update(with: initialParameters)
        #expect(cache.hasChanges(comparedTo: newParameters) == true)
    }

    @Test("hasChanges returns false for empty parameters when cache is empty")
    func testHasChangesReturnsFalseForEmptyParametersWhenCacheIsEmpty() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [:]
        #expect(cache.hasChanges(comparedTo: parameters) == false)
    }

    @Test("hasChanges with string values")
    func testHasChangesWithStringValues() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentType: "article"]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)

        let differentParameters: AnalyticsParameters = [.contentType: "video"]
        #expect(cache.hasChanges(comparedTo: differentParameters) == true)
    }

    @Test("hasChanges with integer values")
    func testHasChangesWithIntegerValues() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.quantity: 5]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)

        let differentParameters: AnalyticsParameters = [.quantity: 10]
        #expect(cache.hasChanges(comparedTo: differentParameters) == true)
    }

    @Test("hasChanges with double values")
    func testHasChangesWithDoubleValues() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.price: 19.99]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)

        let differentParameters: AnalyticsParameters = [.price: 29.99]
        #expect(cache.hasChanges(comparedTo: differentParameters) == true)
    }

    @Test("hasChanges with boolean values")
    func testHasChangesWithBooleanValues() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.success: true]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)

        let differentParameters: AnalyticsParameters = [.success: false]
        #expect(cache.hasChanges(comparedTo: differentParameters) == true)
    }

    @Test("hasChanges with nil values")
    func testHasChangesWithNilValues() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentId: nil]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)
    }

    @Test("hasChanges returns true when cached value is nil but new value is not")
    func testHasChangesReturnsTrueWhenCachedValueIsNilButNewValueIsNot() {
        let cache = UserPropertyCache()
        let nilParameters: AnalyticsParameters = [.contentId: nil]
        cache.update(with: nilParameters)

        let nonNilParameters: AnalyticsParameters = [.contentId: 1234]
        #expect(cache.hasChanges(comparedTo: nonNilParameters) == true)
    }

    @Test("hasChanges returns true when cached value is not nil but new value is")
    func testHasChangesReturnsTrueWhenCachedValueIsNotNilButNewValueIs() {
        let cache = UserPropertyCache()
        let nonNilParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: nonNilParameters)

        let nilParameters: AnalyticsParameters = [.contentId: nil]
        #expect(cache.hasChanges(comparedTo: nilParameters) == true)
    }

    @Test("hasChanges with multiple parameters all matching")
    func testHasChangesWithMultipleParametersAllMatching() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article",
            .quantity: 1
        ]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)
    }

    @Test("hasChanges with multiple parameters one differs")
    func testHasChangesWithMultipleParametersOneDiffers() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article",
            .quantity: 1
        ]
        cache.update(with: initialParameters)

        let newParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "video",
            .quantity: 1
        ]
        #expect(cache.hasChanges(comparedTo: newParameters) == true)
    }

    @Test("hasChanges only checks provided keys")
    func testHasChangesOnlyChecksProvidedKeys() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article"
        ]
        cache.update(with: initialParameters)

        // Only checking contentId which matches
        let checkParameters: AnalyticsParameters = [.contentId: 1234]
        #expect(cache.hasChanges(comparedTo: checkParameters) == false)
    }

    @Test("hasChanges returns true for uncached keys")
    func testHasChangesReturnsTrueForUncachedKeys() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: initialParameters)

        // Checking a key that was never cached
        let checkParameters: AnalyticsParameters = [.contentType: "article"]
        #expect(cache.hasChanges(comparedTo: checkParameters) == true)
    }

    // MARK: - Removed Values Tests

    @Test("hasChanges detects when a key was removed by setting to nil")
    func testHasChangesDetectsWhenKeyWasRemovedBySettingToNil() {
        let cache = UserPropertyCache()

        // First, cache a value
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: initialParameters)

        // Then update with nil to simulate removal
        let removedParameters: AnalyticsParameters = [.contentId: nil]
        cache.update(with: removedParameters)

        // The cache should now show nil, so checking for original value should show changes
        #expect(cache.hasChanges(comparedTo: initialParameters) == true)
        #expect(cache.hasChanges(comparedTo: removedParameters) == false)
    }

    @Test("hasChanges when comparing removed parameter against new non-nil value")
    func testHasChangesWhenComparingRemovedParameterAgainstNewNonNilValue() {
        let cache = UserPropertyCache()

        // Cache and then "remove" by setting to nil
        cache.update(with: [.contentId: 1234])
        cache.update(with: [.contentId: nil])

        // Now compare against a non-nil value - should detect change
        let newValue: AnalyticsParameters = [.contentId: 5678]
        #expect(cache.hasChanges(comparedTo: newValue) == true)
    }

    @Test("hasChanges with one parameter removed from multi-parameter set")
    func testHasChangesWithOneParameterRemovedFromMultiParameterSet() {
        let cache = UserPropertyCache()

        // Cache multiple parameters
        let fullParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article",
            .quantity: 5
        ]
        cache.update(with: fullParameters)

        // Remove one parameter
        cache.update(with: [.contentType: nil])

        // Check that the full set now has changes (because contentType is nil)
        #expect(cache.hasChanges(comparedTo: fullParameters) == true)

        // But checking only the non-removed parameters should show no changes
        let remainingParameters: AnalyticsParameters = [
            .contentId: 1234,
            .quantity: 5
        ]
        #expect(cache.hasChanges(comparedTo: remainingParameters) == false)
    }

    @Test("hasChanges when all parameters are removed")
    func testHasChangesWhenAllParametersAreRemoved() {
        let cache = UserPropertyCache()

        // Cache parameters
        let parameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article"
        ]
        cache.update(with: parameters)

        // Remove all by setting to nil
        cache.update(with: [
            .contentId: nil,
            .contentType: nil
        ])

        // Original parameters should show changes
        #expect(cache.hasChanges(comparedTo: parameters) == true)

        // Empty parameters should show no changes (since we're checking nothing)
        #expect(cache.hasChanges(comparedTo: [:]) == false)
    }

    @Test("hasChanges detects re-adding a previously removed value")
    func testHasChangesDetectsReAddingPreviouslyRemovedValue() {
        let cache = UserPropertyCache()

        // Add, then remove, then re-add
        cache.update(with: [.contentId: 1234])
        cache.update(with: [.contentId: nil])
        cache.update(with: [.contentId: 5678])

        // Should match new value, not original
        #expect(cache.hasChanges(comparedTo: [.contentId: 5678]) == false)
        #expect(cache.hasChanges(comparedTo: [.contentId: 1234]) == true)
        #expect(cache.hasChanges(comparedTo: [.contentId: nil]) == true)
    }

    @Test("hasChanges when comparing against parameters that include a removed key with value")
    func testHasChangesWhenComparingAgainstParametersThatIncludeRemovedKeyWithValue() {
        let cache = UserPropertyCache()

        // Cache with nil (representing removed)
        cache.update(with: [.contentId: nil])

        // Compare against parameters that have a value for that key
        let parametersWithValue: AnalyticsParameters = [.contentId: 1234]
        #expect(cache.hasChanges(comparedTo: parametersWithValue) == true)
    }

    @Test("hasChanges when parameter is in compare set but was never cached")
    func testHasChangesWhenParameterIsInCompareSetButWasNeverCached() {
        let cache = UserPropertyCache()

        // Cache one parameter
        cache.update(with: [.contentId: 1234])

        // Compare against set that includes an uncached key
        let parametersWithUncachedKey: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article"  // This was never cached
        ]
        #expect(cache.hasChanges(comparedTo: parametersWithUncachedKey) == true)
    }

    @Test("sequential removal and re-addition of multiple parameters")
    func testSequentialRemovalAndReAdditionOfMultipleParameters() {
        let cache = UserPropertyCache()

        // Start with multiple parameters
        cache.update(with: [
            .contentId: 1234,
            .contentType: "article",
            .quantity: 5
        ])

        // Remove contentType
        cache.update(with: [.contentType: nil])

        // Add a new parameter
        cache.update(with: [.price: 9.99])

        // Re-add contentType with different value
        cache.update(with: [.contentType: "video"])

        // Final state check
        let expectedState: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "video",
            .quantity: 5,
            .price: 9.99
        ]
        #expect(cache.hasChanges(comparedTo: expectedState) == false)

        // Old contentType value should show changes
        #expect(cache.hasChanges(comparedTo: [.contentType: "article"]) == true)
    }

    // MARK: - update Tests

    @Test("update stores new parameters")
    func testUpdateStoresNewParameters() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)
    }

    @Test("update overwrites existing parameters")
    func testUpdateOverwritesExistingParameters() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: initialParameters)

        let newParameters: AnalyticsParameters = [.contentId: 5678]
        cache.update(with: newParameters)

        #expect(cache.hasChanges(comparedTo: newParameters) == false)
        #expect(cache.hasChanges(comparedTo: initialParameters) == true)
    }

    @Test("update preserves unmodified parameters")
    func testUpdatePreservesUnmodifiedParameters() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article"
        ]
        cache.update(with: initialParameters)

        // Update only contentType
        let partialUpdate: AnalyticsParameters = [.contentType: "video"]
        cache.update(with: partialUpdate)

        // Original contentId should still be cached
        let contentIdCheck: AnalyticsParameters = [.contentId: 1234]
        #expect(cache.hasChanges(comparedTo: contentIdCheck) == false)

        // Updated contentType should be cached
        let contentTypeCheck: AnalyticsParameters = [.contentType: "video"]
        #expect(cache.hasChanges(comparedTo: contentTypeCheck) == false)
    }

    @Test("update with empty parameters does not affect cache")
    func testUpdateWithEmptyParametersDoesNotAffectCache() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: initialParameters)

        let emptyParameters: AnalyticsParameters = [:]
        cache.update(with: emptyParameters)

        #expect(cache.hasChanges(comparedTo: initialParameters) == false)
    }

    @Test("update with nil value stores nil")
    func testUpdateWithNilValueStoresNil() {
        let cache = UserPropertyCache()
        let parameters: AnalyticsParameters = [.contentId: nil]
        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)
    }

    @Test("update replaces non-nil value with nil")
    func testUpdateReplacesNonNilValueWithNil() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: initialParameters)

        let nilParameters: AnalyticsParameters = [.contentId: nil]
        cache.update(with: nilParameters)

        #expect(cache.hasChanges(comparedTo: nilParameters) == false)
        #expect(cache.hasChanges(comparedTo: initialParameters) == true)
    }

    @Test("update replaces nil value with non-nil")
    func testUpdateReplacesNilValueWithNonNil() {
        let cache = UserPropertyCache()
        let nilParameters: AnalyticsParameters = [.contentId: nil]
        cache.update(with: nilParameters)

        let nonNilParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: nonNilParameters)

        #expect(cache.hasChanges(comparedTo: nonNilParameters) == false)
        #expect(cache.hasChanges(comparedTo: nilParameters) == true)
    }

    @Test("multiple sequential updates")
    func testMultipleSequentialUpdates() {
        let cache = UserPropertyCache()

        cache.update(with: [.contentId: 1])
        #expect(cache.hasChanges(comparedTo: [.contentId: 1]) == false)

        cache.update(with: [.contentId: 2])
        #expect(cache.hasChanges(comparedTo: [.contentId: 2]) == false)
        #expect(cache.hasChanges(comparedTo: [.contentId: 1]) == true)

        cache.update(with: [.contentId: 3])
        #expect(cache.hasChanges(comparedTo: [.contentId: 3]) == false)
        #expect(cache.hasChanges(comparedTo: [.contentId: 2]) == true)
    }

    @Test("update accumulates multiple keys over time")
    func testUpdateAccumulatesMultipleKeysOverTime() {
        let cache = UserPropertyCache()

        cache.update(with: [.contentId: 1234])
        cache.update(with: [.contentType: "article"])
        cache.update(with: [.quantity: 5])

        let allParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article",
            .quantity: 5
        ]
        #expect(cache.hasChanges(comparedTo: allParameters) == false)
    }

    // MARK: - Edge Cases

    @Test("custom parameter keys work correctly")
    func testCustomParameterKeysWorkCorrectly() {
        let cache = UserPropertyCache()
        let customKey = AnalyticsParameter("custom_user_property")
        let parameters: AnalyticsParameters = [customKey: "custom_value"]

        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)

        let differentValue: AnalyticsParameters = [customKey: "different_value"]
        #expect(cache.hasChanges(comparedTo: differentValue) == true)
    }

    @Test("large number of parameters")
    func testLargeNumberOfParameters() {
        let cache = UserPropertyCache()
        var parameters: AnalyticsParameters = [:]

        // Add many parameters
        parameters[.contentId] = 1
        parameters[.contentType] = "type"
        parameters[.creativeName] = "name"
        parameters[.creativeSlot] = "slot"
        parameters[.promotionId] = "promo_id"
        parameters[.promotionName] = "promo_name"
        parameters[.elementName] = "elem_name"
        parameters[.elementValue] = "elem_value"
        parameters[.elementType] = "elem_type"
        parameters[.quantity] = 10

        cache.update(with: parameters)
        #expect(cache.hasChanges(comparedTo: parameters) == false)

        // Change just one parameter
        var modifiedParameters = parameters
        modifiedParameters[.quantity] = 20
        #expect(cache.hasChanges(comparedTo: modifiedParameters) == true)
    }

    @Test("subset of cached parameters")
    func testSubsetOfCachedParameters() {
        let cache = UserPropertyCache()
        let fullParameters: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article",
            .quantity: 5
        ]
        cache.update(with: fullParameters)

        // Check only a subset of the cached parameters
        let subset: AnalyticsParameters = [
            .contentId: 1234,
            .quantity: 5
        ]
        #expect(cache.hasChanges(comparedTo: subset) == false)
    }

    @Test("superset of cached parameters")
    func testSupersetOfCachedParameters() {
        let cache = UserPropertyCache()
        let initialParameters: AnalyticsParameters = [.contentId: 1234]
        cache.update(with: initialParameters)

        // Check more parameters than what's cached
        let superset: AnalyticsParameters = [
            .contentId: 1234,
            .contentType: "article"
        ]
        #expect(cache.hasChanges(comparedTo: superset) == true)
    }
}
