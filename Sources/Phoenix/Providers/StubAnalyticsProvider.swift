//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
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
    
    public func setUserProperty(_ property: AnalyticsUserProperty, to value: AnalyticsParameterValue?) {
    }
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
    }
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String, parameters: AnalyticsParameters?) {
    }
    
    public func logEvent(_ event: AnalyticsEvent, additionalParameters: AnalyticsParameters) {
    }
    
    public func logTransaction(_ transaction: Transaction) {
    }
}
