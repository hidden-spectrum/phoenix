//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import MetricKit


public extension AnalyticsEvent {
    static func mxDiagnosticPayload(_ payload: MXDiagnosticPayload) -> Self {
        print(payload.analyticsParameters)
        return Event("mx_diagnostic_payload", parameters: payload.analyticsParameters)
    }
}


extension MXDiagnosticPayload: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        dictionaryRepresentation().reduce(into: AnalyticsParameters()) { result, pair in
            let (rawKey, rawValue) = pair
            guard let key = rawKey as? String, let value = rawValue as? AnalyticsParameterValue else {
                return
            }
            result[AnalyticsParameter("mx_diagnostic_\(key)")] = value
        }
    }
}
