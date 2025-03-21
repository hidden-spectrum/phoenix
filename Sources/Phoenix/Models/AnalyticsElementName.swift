//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsElementName: ExpressibleByStringLiteral {
    
    // MARK: Public
    
    public typealias ElementName = AnalyticsElementName
    
    // MARK: Internal
    
    let stringValue: String
    
    // MARK: Lifecycle
    
    public init(stringLiteral value: StringLiteralType) {
        self.stringValue = value
    }
    
    public init(_ value: StringLiteralType) {
        self.stringValue = value
    }
}

extension AnalyticsElementName: AnalyticsParameterValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        stringValue
    }
}

extension AnalyticsElementName: Equatable {
}
