//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import MetricKit


public extension AnalyticsEvent {
    static func mxDiagnosticPayload(_ payload: MXDiagnosticPayload) -> Self {
        return Event("mx_diagnostic_payload", parameters: payload.analyticsParameters)
    }
    
    static func mxMetricPayload(_ payload: MXMetricPayload) -> Self {
        return Event("mx_metric_payload", parameters: payload.analyticsParameters)
    }
}


extension MXDiagnosticPayload: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        [:]
    }
}

extension MXMetricPayload: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        var parameters = AnalyticsParameters()
        if let foregroundExits = applicationExitMetrics?.foregroundExitData {
            parameters[.mxAppExitForegroundData] = [
                .mxCumulativeNormalAppExitCount: foregroundExits.cumulativeNormalAppExitCount,
                .mxCumulativeAbnormalExitCount: foregroundExits.cumulativeAbnormalExitCount,
                .mxCumulativeAppWatchdogExitCount: foregroundExits.cumulativeAppWatchdogExitCount,
                .mxCumulativeMemoryResourceLimitExitCount: foregroundExits.cumulativeMemoryResourceLimitExitCount,
                .mxCumulativeBadAccessExitCount: foregroundExits.cumulativeBadAccessExitCount,
                .mxCumulativeIllegalInstructionExitCount: foregroundExits.cumulativeIllegalInstructionExitCount,
            ]
        }
        if let backgroundExits = applicationExitMetrics?.backgroundExitData {
            parameters[.mxAppExitBackgroundData] = [
                .mxCumulativeNormalAppExitCount: backgroundExits.cumulativeNormalAppExitCount,
                .mxCumulativeAbnormalExitCount: backgroundExits.cumulativeAbnormalExitCount,
                .mxCumulativeAppWatchdogExitCount: backgroundExits.cumulativeAppWatchdogExitCount,
                .mxCumulativeMemoryResourceLimitExitCount: backgroundExits.cumulativeMemoryResourceLimitExitCount,
                .mxCumulativeBadAccessExitCount: backgroundExits.cumulativeBadAccessExitCount,
                .mxCumulativeIllegalInstructionExitCount: backgroundExits.cumulativeIllegalInstructionExitCount,
            ]
        }
        return parameters
    }
}


extension AnalyticsParameter {
    static let mxAppExitForegroundData = Parameter("mx_app_exit_foreground_data")
    static let mxCumulativeNormalAppExitCount = Parameter("mx_cumulative_normal_app_exit_count")
    static let mxCumulativeAbnormalExitCount = Parameter("mx_cumulative_abnormal_exit_count")
    static let mxCumulativeAppWatchdogExitCount = Parameter("mx_cumulative_app_watchdog_exit_count")
    static let mxCumulativeMemoryResourceLimitExitCount = Parameter("mx_cumulative_memory_resource_limit_exit_count")
    static let mxCumulativeBadAccessExitCount = Parameter("mx_cumulative_bad_access_exit_count")
    static let mxCumulativeIllegalInstructionExitCount = Parameter("mx_cumulative_illegal_instruction_exit_count")
    
    static let mxAppExitBackgroundData = Parameter("mx_app_exit_background_data")
    
}
