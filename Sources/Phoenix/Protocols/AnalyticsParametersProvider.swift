//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsParametersProvider {
    var analyticsParameters: AnalyticsParameters { get }
}

public extension AnalyticsParametersProvider where Self: Equatable {
    func isEqualTo(_ other: AnalyticsParameterValue?) -> Bool {
        if let other = other as? Self {
            return self == other
        }
        return false
    }
}

extension AnalyticsParametersProvider {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        analyticsParameters.analyticsSupportedValue
    }
}
