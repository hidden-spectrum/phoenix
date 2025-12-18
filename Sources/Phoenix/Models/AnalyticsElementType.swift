//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsElementType: Equatable {
    
    // MARK: Public
    
    public typealias ElementType = Self
    
    // MARK: Internal
    
    let rawValue: String
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension AnalyticsElementType {
    static let button   = ElementType("button")
    static let cell     = ElementType("cell")
    static let listRow  = ElementType("list_row")
    static let number   = ElementType("number")
    static let tab      = ElementType("tab")
    static let text     = ElementType("text")
    static let toggle   = ElementType("toggle")
}

extension AnalyticsElementType: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { rawValue }
}

