//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


protocol AnalyticsDimensionValue: AnalyticsParameterValue {
}

extension Bool: AnalyticsDimensionValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        self
    }
}

extension StringLiteralType: AnalyticsDimensionValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        self
    }
}
