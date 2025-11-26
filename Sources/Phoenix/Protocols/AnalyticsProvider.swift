//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import MetricKit
import StoreKit


public protocol AnalyticsProvider {
    func setup()
    
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
}

public extension AnalyticsProvider {
    func logTransaction(_ transaction: Transaction) {
        logEvent(.appStoreTransaction(transaction), on: nil, additionalParameters: [:])
    }
    
    func logCrash(_ crash: MXCrashDiagnostic) {
    }
}
