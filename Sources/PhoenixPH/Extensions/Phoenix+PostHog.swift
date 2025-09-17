//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix


extension AnalyticsEvent {
    static let exception = Event("$exception")
}


extension AnalyticsParameter {
    static let exceptionList = Parameter("$exception_list")
    static let screenName = Parameter("$screen_name")
    static let type = Parameter("type")
    static let value = Parameter("value")
}
