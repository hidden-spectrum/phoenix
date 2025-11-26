//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix


extension AnalyticsEvent {
    static func exception(type: String, value: String, mechanismType: String? = nil, handled: Bool = false) -> Event {
        var exceptionDetails: AnalyticsParameters = [
            .type: type,
            .value: value,
            .mechanism: [
                .type: mechanismType,
                .handled: handled
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
    
    static let mechanism = Parameter("mechanism")
    static let handled = Parameter("handled")
    
    static let virtualMemoryRegionInfo = Parameter("virtual_memory_region_info")
}
