//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


/// A feature flag whose remote payload has type `Value`.
public struct AnalyticsFeatureFlag<Value: Sendable>: Sendable {
    
    // MARK: Public
    
    public typealias Feature = Self
    
    // MARK: Internal
    
    public let rawValue: String
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension AnalyticsFeatureFlag: Equatable {
}

extension AnalyticsFeatureFlag: Hashable {
}
