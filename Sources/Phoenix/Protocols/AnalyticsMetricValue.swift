//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsMetricValue: AnalyticsParameterValue {
}

extension Double: AnalyticsMetricValue {}
extension Int: AnalyticsMetricValue {}
extension Int64: AnalyticsMetricValue {}
