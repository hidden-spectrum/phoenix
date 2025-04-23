//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsSupportedParameterValue: Sendable {
    func isEqualTo(_ other: AnalyticsSupportedParameterValue?) -> Bool
}

public extension AnalyticsSupportedParameterValue where Self: Equatable {
    func isEqualTo(_ other: AnalyticsSupportedParameterValue?) -> Bool {
        if let other = other as? Self {
            return self == other
        }
        return false
    }
}

// MARK: Common Supported Parameter Values

extension Array: AnalyticsSupportedParameterValue where Element == Sendable {
    public func isEqualTo(_ other: AnalyticsSupportedParameterValue?) -> Bool {
        return true
    }
}
extension Dictionary: AnalyticsSupportedParameterValue where Key == String, Value == AnalyticsSupportedParameterValue {
    public func isEqualTo(_ other: AnalyticsSupportedParameterValue?) -> Bool {
        return true
    }
}

extension Bool: AnalyticsSupportedParameterValue {}
extension Double: AnalyticsSupportedParameterValue {}
extension Int: AnalyticsSupportedParameterValue {}
extension Int64: AnalyticsSupportedParameterValue {}
extension String: AnalyticsSupportedParameterValue {}
