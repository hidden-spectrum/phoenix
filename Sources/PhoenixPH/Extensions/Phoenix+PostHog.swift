//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix


extension AnalyticsEvent {
    
    static func error(_ error: Error) -> Event {
        let parameters: AnalyticsParameters = [
            .errorType: String(reflecting: type(of: error)),
            .errorValue: String(reflecting: error),
        ]
        
        return Event("error", parameters: parameters)
    }
}


extension AnalyticsParameter {
    static let screenName = Parameter("$screen_name")
}
