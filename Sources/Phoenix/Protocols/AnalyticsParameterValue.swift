//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsParameterValue: Sendable {
    var analyticsSupportedValue: AnalyticsSupportedParameterValue { get }
}

extension AnalyticsParameterValue where Self: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.analyticsSupportedValue.isEqualTo(rhs.analyticsSupportedValue)
    }
}

extension Array: AnalyticsParameterValue where Element: AnalyticsParameterValue & AnalyticsSupportedParameterValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        map { $0.analyticsSupportedValue }
    }
}

extension Optional: AnalyticsParameterValue where Wrapped: AnalyticsParameterValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        self?.analyticsSupportedValue
    }
}

extension RawRepresentable where RawValue: AnalyticsSupportedParameterValue, Self: AnalyticsParameterValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        rawValue
    }
}

