//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsExperimentVariant: RawRepresentable, Equatable, Sendable where RawValue == String {
}


public struct AnalyticsExperiment<Variant: AnalyticsExperimentVariant>: Sendable {
    
    // MARK: Publict
    
    public typealias Expirement = Self
    
    // MARK: Internal
    
    public let rawValue: String
    public let variantType: Variant.Type
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String, variantType: Variant.Type) {
        self.rawValue = rawValue
        self.variantType = variantType
    }
}

extension AnalyticsExperiment: Equatable {
    public static func == (lhs: AnalyticsExperiment<Variant>, rhs: AnalyticsExperiment<Variant>) -> Bool {
        return lhs.rawValue == rhs.rawValue && lhs.variantType == rhs.variantType
    }
}
