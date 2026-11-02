//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import CoreData
import Foundation
import Testing


@Suite("AnalyticsErrorParameters Tests")
struct AnalyticsErrorParametersTests {
    
    private enum NativeError: Error {
        case failure
    }
    
    private enum DescribedError: LocalizedError {
        case failure
        
        var failureReason: String? { "Missing attachment" }
        var recoverySuggestion: String? { "Retry the download" }
    }
    
    private let leaf: NSError
    
    init() {
        leaf = NSError(domain: "Storage", code: 7)
    }
    
    @Test("Swift-native errors retain their reflected type and value")
    func nativeError() {
        let error = NativeError.failure
        let expected: AnalyticsParameters = [
            .errorType: String(reflecting: type(of: error)),
            .errorValue: String(reflecting: error),
        ]
        
        #expect(AnalyticsErrorParameters(for: error).analyticsParameters == expected)
    }
    
    @Test("Swift LocalizedError failure reasons and recovery suggestions are captured")
    func localizedError() {
        let error = DescribedError.failure
        let expected: AnalyticsParameters = [
            .errorType: String(reflecting: type(of: error)),
            .errorValue: String(reflecting: error),
            .errorFailureReason: "Missing attachment",
            .errorRecoverySuggestion: "Retry the download",
        ]
        
        #expect(AnalyticsErrorParameters(for: error).analyticsParameters == expected)
    }
    
    @Test("NSError includes diagnostic messages without copying arbitrary userInfo")
    func nsError() {
        let error = NSError(domain: NSCocoaErrorDomain, code: 134040, userInfo: [
            NSLocalizedFailureReasonErrorKey: "A store failed",
            NSLocalizedRecoverySuggestionErrorKey: "Retry",
            NSFilePathErrorKey: "/private/attachment",
            "record": ["name": "Private contact"],
        ])
        let expected: AnalyticsParameters = [
            .errorType: NSCocoaErrorDomain,
            .errorValue: "134040",
            .errorFailureReason: "A store failed",
            .errorRecoverySuggestion: "Retry",
        ]
        
        #expect(AnalyticsErrorParameters(for: error).analyticsParameters == expected)
    }
    
    @Test("Underlying, multiple, and detailed errors preserve their parent relationships")
    func nestedErrors() throws {
        let wrapper = NSError(domain: "Wrapper", code: 2, userInfo: [NSDetailedErrorsKey: [leaf]])
        let error = NSError(domain: "Root", code: 1, userInfo: [
            NSUnderlyingErrorKey: wrapper,
            NSMultipleUnderlyingErrorsKey: [leaf],
        ])
        let parameters = AnalyticsErrorParameters(for: error).analyticsParameters
        let expected: [[String: Any]] = [
            ["error_type": "Wrapper", "error_value": "2", "source": NSUnderlyingErrorKey],
            ["error_type": "Storage", "error_value": "7", "source": NSDetailedErrorsKey, "parent_index": 0],
            ["error_type": "Storage", "error_value": "7", "source": NSMultipleUnderlyingErrorsKey],
        ]
        
        #expect(try decodedNestedErrors(in: parameters) == NSArray(array: expected))
        #expect(parameters[.errorUnderlyingType] as? String == "Wrapper")
        #expect(parameters[.errorUnderlyingValue] as? String == "2")
        #expect(parameters[.errorDetailsTruncated] == nil)
    }
    
    @Test("Detailed errors are captured even without an NSUnderlyingError", arguments: [NSMultipleUnderlyingErrorsKey, NSDetailedErrorsKey])
    func errorArrays(key: String) throws {
        let error = NSError(domain: "Root", code: 1, userInfo: [key: [leaf]])
        let parameters = AnalyticsErrorParameters(for: error).analyticsParameters
        let expected: [[String: Any]] = [
            ["error_type": "Storage", "error_value": "7", "source": key],
        ]
        
        #expect(try decodedNestedErrors(in: parameters) == NSArray(array: expected))
        #expect(parameters[.errorUnderlyingType] == nil)
        #expect(parameters[.errorUnderlyingValue] == nil)
    }
    
    @Test("Nested error count is capped at 16 and omissions are marked", arguments: [16, 17])
    func countLimit(count: Int) throws {
        let children = (0..<count).map { NSError(domain: "Child", code: $0) }
        let error = NSError(domain: "Root", code: 1, userInfo: [NSDetailedErrorsKey: children])
        let parameters = AnalyticsErrorParameters(for: error).analyticsParameters
        let expected: [[String: Any]] = (0..<16).map {
            ["error_type": "Child", "error_value": String($0), "source": NSDetailedErrorsKey]
        }
        
        #expect(try decodedNestedErrors(in: parameters) == NSArray(array: expected))
        #expect((parameters[.errorDetailsTruncated] as? Bool) == (count > 16 ? true : nil))
    }
    
    @Test("Nested errors stop after four levels and omissions are marked", arguments: [4, 5])
    func depthLimit(depth: Int) throws {
        var error = NSError(domain: "Chain", code: depth)
        for code in (0..<depth).reversed() {
            error = NSError(domain: "Chain", code: code, userInfo: [NSUnderlyingErrorKey: error])
        }
        let parameters = AnalyticsErrorParameters(for: error).analyticsParameters
        let expected: [[String: Any]] = (1...4).map { code in
            var entry: [String: Any] = ["error_type": "Chain", "error_value": String(code), "source": NSUnderlyingErrorKey]
            if code > 1 {
                entry["parent_index"] = code - 2
            }
            return entry
        }
        
        #expect(try decodedNestedErrors(in: parameters) == NSArray(array: expected))
        #expect((parameters[.errorDetailsTruncated] as? Bool) == (depth > 4 ? true : nil))
    }
    
    @Test("Diagnostic strings are limited to 1024 characters", arguments: [1024, 1025])
    func stringLimit(length: Int) {
        let message = String(repeating: "é", count: length)
        let error = NSError(domain: "Root", code: 1, userInfo: [
            NSLocalizedFailureReasonErrorKey: message,
            NSLocalizedRecoverySuggestionErrorKey: message,
        ])
        let limitedMessage = String(repeating: "é", count: 1024)
        let expected: AnalyticsParameters = [
            .errorType: "Root",
            .errorValue: "1",
            .errorFailureReason: limitedMessage,
            .errorRecoverySuggestion: limitedMessage,
        ]
        
        #expect(AnalyticsErrorParameters(for: error).analyticsParameters == expected)
    }
    
    private func decodedNestedErrors(in parameters: AnalyticsParameters) throws -> NSArray {
        let json = try #require(parameters[.errorNestedErrors] as? String)
        return try #require(JSONSerialization.jsonObject(with: Data(json.utf8)) as? NSArray)
    }
}
