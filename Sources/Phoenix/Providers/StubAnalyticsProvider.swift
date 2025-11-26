//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import MetricKit
import StoreKit


public struct StubAnalyticsProvider: AnalyticsProvider {
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    // MARK: AnalyticsProvider
    
    public func setup() {
    }
    
    public func setUserId(_ userId: String?) {
    }
    
    public func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?) {
    }
    
    public func setUserProperties(_ properties: AnalyticsParameters) {
    }
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
    }
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String? = nil, parameters: AnalyticsParameters?) {
    }
    
    public func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
    }
    
    public func logCrash(_ crash: MXCrashDiagnostic) {
    }
}
