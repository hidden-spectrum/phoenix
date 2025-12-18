//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsFeatureFlag: Sendable {
    
    // MARK: Publict
    
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
