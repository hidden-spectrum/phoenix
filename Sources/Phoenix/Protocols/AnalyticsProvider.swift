//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import MetricKit
import StoreKit


public protocol AnalyticsProvider {
    func setup()
    func flush()
    
    func setUserId(_ userId: String?)
    func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?)
    func setUserProperties(_ properties: AnalyticsParameters)
    
    func registerGlobalProperties(_ properties: AnalyticsParameters)
    func unregisterGlobalProperty(_ property: AnalyticsParameter)
    
    func logScreenView(_ screen: AnalyticsScreen, class screenClass: String?, parameters: AnalyticsParameters?)
    func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters)
    
    func logTransaction(_ transaction: Transaction)
    
    func logError(_ error: Error, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters)
    func logCrash(_ crash: MXCrashDiagnostic)
    
    func reloadFeatureFlags() async
    func featureEnabled(_ feature: AnalyticsFeatureFlag) -> Bool
    func enabledVariant<Variant: AnalyticsExperimentVariant>(for experiment: AnalyticsExperiment<Variant>) -> Variant?
    func overrideFeatureFlag(_ feature: AnalyticsFeatureFlag, enabled: Bool)
    func overrideExpirement<Variant: AnalyticsExperimentVariant>(_ expirement: AnalyticsExperiment<Variant>, to variant: Variant)
}

public extension AnalyticsProvider {
    func flush() {}
    
    func logTransaction(_ transaction: Transaction) {
        logEvent(.appStoreTransaction(transaction), on: nil, additionalParameters: [:])
    }
    
    func logCrash(_ crash: MXCrashDiagnostic) {}
    
    func reloadFeatureFlags() async {}
    func featureEnabled(_ feature: AnalyticsFeatureFlag) -> Bool { false }
    func enabledVariant<Variant: AnalyticsExperimentVariant>(for experiment: AnalyticsExperiment<Variant>) -> Variant? { nil }
    
    func overrideFeatureFlag(_ feature: AnalyticsFeatureFlag, enabled: Bool) {}
    func overrideExpirement<Variant: AnalyticsExperimentVariant>(_ expirement: AnalyticsExperiment<Variant>, to variant: Variant) {}
}
