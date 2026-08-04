//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Foundation
import Testing


@Suite("Analytics Error Parameters Tests")
struct AnalyticsErrorParametersTests {
    
    private enum NativeError: Error {
        case failure
    }
    
    @Test("Swift-native errors use reflected type and value")
    func nativeError() {
        let error = NativeError.failure
        let errorParameters = AnalyticsErrorParameters(for: error)
        let expectedParameters: AnalyticsParameters = [
            .errorType: String(reflecting: type(of: error)),
            .errorValue: String(reflecting: error),
        ]
        
        #expect(errorParameters.parameters == expectedParameters)
    }
    
    @Test("NSError uses domain and code for itself and its underlying error")
    func nsError() {
        let underlyingError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNetworkConnectionLost)
        let error = NSError(
            domain: "CKErrorDomain",
            code: 4,
            userInfo: [NSUnderlyingErrorKey: underlyingError]
        )
        let errorParameters = AnalyticsErrorParameters(for: error)
        let expectedParameters: AnalyticsParameters = [
            .errorType: "CKErrorDomain",
            .errorValue: "4",
            .errorUnderlyingType: NSURLErrorDomain,
            .errorUnderlyingValue: String(NSURLErrorNetworkConnectionLost),
        ]
        
        #expect(errorParameters.parameters == expectedParameters)
    }
}
