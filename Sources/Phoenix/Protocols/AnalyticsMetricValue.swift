//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsMetricValue: AnalyticsParameterValue {
}

extension Double: AnalyticsMetricValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        self
    }
}

extension Int: AnalyticsMetricValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        self
    }
}

extension Int64: AnalyticsMetricValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        self
    }
}
