//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix
import PostHog


extension AnalyticsLogLevel {
    var postHogLevel: PostHogLogSeverity {
        switch self {
        case .trace: .trace
        case .debug: .debug
        case .info: .info
        case .warning: .warn
        case .error: .error
        case .fatal: .fatal
        }
    }
}


extension AnalyticsParameter {
    static let screenName = Parameter("$screen_name")
}
