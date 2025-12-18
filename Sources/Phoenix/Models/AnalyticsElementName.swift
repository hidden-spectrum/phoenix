//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsElementName: Equatable, ExpressibleByStringLiteral {
    
    // MARK: Public
    
    public typealias ElementName = AnalyticsElementName
    
    public let stringValue: String
    
    // MARK: Lifecycle
    
    public init(stringLiteral value: StringLiteralType) {
        self.stringValue = value
    }
    
    public init(_ value: StringLiteralType) {
        self.stringValue = value
    }
}

extension AnalyticsElementName: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { stringValue }
}
