//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public protocol AnalyticsElement {
    var analyticsName: AnalyticsElementName { get }
    var analyticsType: AnalyticsElementType { get }
    var analyticsValue: AnalyticsParameterValue? { get }
}

public extension AnalyticsElement {
    var analyticsValue: AnalyticsParameterValue? { nil }
}
