//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsParameterValue: Sendable {
    var analyticsSupportedValue: Any { get }
}


extension Array: AnalyticsParameterValue where Element: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any {
        map { $0.analyticsSupportedValue }
    }
}
extension Bool: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { self }
}
extension Date: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { self }
}
extension Decimal: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { Double(truncating: self as NSDecimalNumber) }
}
extension Double: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { self }
}
extension Int: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { self }
}
extension Int64: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { self }
}
extension RawRepresentable where RawValue: AnalyticsParameterValue, Self: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { rawValue }
}
extension String: AnalyticsParameterValue {
    public var analyticsSupportedValue: Any { self }
}
