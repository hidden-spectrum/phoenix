//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix


public extension AnalyticsEvent {
    static let exception = Event("$exception")
}


public extension AnalyticsParameter {
    static let exceptionMessage = Parameter("$exception_message")
    static let exceptionStacktrace = Parameter("$exception_stacktrace")
    static let exceptionType = Parameter("$exception_type")
}