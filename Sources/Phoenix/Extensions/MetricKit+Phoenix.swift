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
        [:] // TODO: Implement
    }
}

extension MXMetricPayload: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        var parameters = AnalyticsParameters()
        if let foregroundExits = applicationExitMetrics?.foregroundExitData {
            parameters.combine(with: [
                .mxFGNormalAppExitCount: foregroundExits.cumulativeNormalAppExitCount,
                .mxFGAbnormalExitCount: foregroundExits.cumulativeAbnormalExitCount,
                .mxFGAppWatchdogExitCount: foregroundExits.cumulativeAppWatchdogExitCount,
                .mxFGMemoryResourceLimitExitCount: foregroundExits.cumulativeMemoryResourceLimitExitCount,
                .mxFGBadAccessExitCount: foregroundExits.cumulativeBadAccessExitCount,
                .mxFGIllegalInstructionExitCount: foregroundExits.cumulativeIllegalInstructionExitCount
            ])
        }
        if let backgroundExits = applicationExitMetrics?.backgroundExitData {
            parameters.combine(with: [
                .mxBGNormalAppExitCount: backgroundExits.cumulativeNormalAppExitCount,
                .mxBGAbnormalExitCount: backgroundExits.cumulativeAbnormalExitCount,
                
                .mxBGAppWatchdogExitCount: backgroundExits.cumulativeAppWatchdogExitCount,
                .mxBGCPUResourceExitCount: backgroundExits.cumulativeCPUResourceLimitExitCount,
                .mxBGMemoryResourceLimitExitCount: backgroundExits.cumulativeMemoryResourceLimitExitCount,
                .mxBGMemoryPressureExitCount: backgroundExits.cumulativeMemoryPressureExitCount,
                .mxBGSuspendedWithLockedFileExitCount: backgroundExits.cumulativeSuspendedWithLockedFileExitCount,
                
                .mxBGBadAccessExitCount: backgroundExits.cumulativeBadAccessExitCount,
                .mxBGIllegalInstructionExitCount: backgroundExits.cumulativeIllegalInstructionExitCount,
                
                .mxBGTaskAssertionTimeoutExitCount: backgroundExits.cumulativeBackgroundTaskAssertionTimeoutExitCount
            ])
        }
        return parameters
    }
}


public extension AnalyticsParameter {
    
    // Crashes
    
    static let mxCrashVirtualMemoryRegionInfo = Parameter("mx_crash_virtual_memory_region_info")
    
    // Foreground Exits
    
    static let mxFGNormalAppExitCount = Parameter("mx_fg_normal_app_exit_count")
    
    static let mxFGAbnormalExitCount = Parameter("mx_fg_abnormal_exit_count")
    
    static let mxFGAppWatchdogExitCount = Parameter("mx_fg_app_watchdog_exit_count")
    static let mxFGMemoryResourceLimitExitCount = Parameter("mx_fg_memory_resource_limit_exit_count")
    static let mxFGBadAccessExitCount = Parameter("mx_fg_bad_access_exit_count")
    static let mxFGIllegalInstructionExitCount = Parameter("mx_fg_illegal_instruction_exit_count")
    
    // Background Exits
    
    static let mxBGNormalAppExitCount = Parameter("mx_bg_normal_app_exit_count")
    
    static let mxBGAbnormalExitCount = Parameter("mx_bg_abnormal_exit_count")
    
    static let mxBGAppWatchdogExitCount = Parameter("mx_bg_app_watchdog_exit_count")
    static let mxBGCPUResourceExitCount = Parameter("mx_bg_cpu_resource_exit_count")
    static let mxBGMemoryResourceLimitExitCount = Parameter("mx_bg_memory_resource_limit_exit_count")
    static let mxBGMemoryPressureExitCount = Parameter("mx_bg_memory_pressure_exit_count")
    static let mxBGSuspendedWithLockedFileExitCount = Parameter("mx_bg_suspended_with_locked_file_exit_count")
    
    static let mxBGBadAccessExitCount = Parameter("mx_bg_bad_access_exit_count")
    static let mxBGIllegalInstructionExitCount = Parameter("mx_bg_illegal_instruction_exit_count")
    
    static let mxBGTaskAssertionTimeoutExitCount = Parameter("mx_bg_task_assertion_timeout_exit_count")
}
