//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix


extension AnalyticsEvent {
    static func exception(type: String, value: String, mechanismType: String? = nil, handled: Bool = false, stackTraceFrames: [AnalyticsParameters] = []) -> Event {
        let exceptionDetails: AnalyticsParameters = [
            .type: type,
            .value: value,
            .mechanism: [
                .type: mechanismType,
                .handled: handled
            ],
            .stacktrace: [
                .type: "raw",
                .frames: stackTraceFrames
            ]
        ]
        
        let parameters: AnalyticsParameters = [
            .exceptionList: [exceptionDetails]
        ]
        return Event("$exception", parameters: parameters)
    }
}


extension AnalyticsParameter {
    static let screenName = Parameter("$screen_name")
    
    static let exceptionList = Parameter("$exception_list")
    static let type = Parameter("type")
    static let value = Parameter("value")
    
    static let stacktrace = Parameter("stacktrace")
    static let frames = Parameter("frames")
    static let platform = Parameter("platform")
    static let lang = AnalyticsParameter("lang")
    
    static let mechanism = Parameter("mechanism")
    static let handled = Parameter("handled")
    
    static let filename = Parameter("filename")
    static let function = Parameter("function")
    static let lineno = Parameter("lineno")
    static let inApp = Parameter("in_app")
    static let absPath = Parameter("abs_path")
}
