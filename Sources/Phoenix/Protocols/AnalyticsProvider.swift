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
    func setUserId(_ userId: String?, userProperties: AnalyticsParameters)
    func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?)
    func setUserProperties(_ properties: AnalyticsParameters)
    
    func registerGlobalProperties(_ properties: AnalyticsParameters)
    func unregisterGlobalProperty(_ property: AnalyticsParameter)
    
    func logScreenView(_ screen: AnalyticsScreen, class screenClass: String?, parameters: AnalyticsParameters?)
    func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters)
    
    func logTransaction(_ transaction: Transaction)
    
    func log(_ level: AnalyticsLogLevel, message: String, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters)
    func logCrash(_ crash: MXCrashDiagnostic)
    
    func reloadFeatureFlags() async
    func featureEnabled<Value>(_ feature: AnalyticsFeatureFlag<Value>) -> Bool
    func featureFlagValue<Value>(_ feature: AnalyticsFeatureFlag<Value>) -> Value?
    func featureFlagValue<Value: Decodable>(_ feature: AnalyticsFeatureFlag<Value>) -> Value?
    func enabledVariant<Variant: AnalyticsExperimentVariant>(for experiment: AnalyticsExperiment<Variant>) -> Variant?
}

public extension AnalyticsProvider {
    func flush() {}

    func setUserId(_ userId: String?, userProperties: AnalyticsParameters) {
        setUserId(userId)
    }
    
    func logTransaction(_ transaction: Transaction) {
        logEvent(.appStoreTransaction(transaction), on: nil, additionalParameters: [:])
    }
    
    func logCrash(_ crash: MXCrashDiagnostic) {}
    
    func reloadFeatureFlags() async {}
    func featureEnabled<Value>(_ feature: AnalyticsFeatureFlag<Value>) -> Bool { false }
    func featureFlagValue<Value>(_ feature: AnalyticsFeatureFlag<Value>) -> Value? { nil }
    func featureFlagValue<Value: Decodable>(_ feature: AnalyticsFeatureFlag<Value>) -> Value? { nil }
    func enabledVariant<Variant: AnalyticsExperimentVariant>(for experiment: AnalyticsExperiment<Variant>) -> Variant? { nil }
}
