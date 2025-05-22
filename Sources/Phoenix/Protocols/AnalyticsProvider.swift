//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import StoreKit


public protocol AnalyticsProvider {
    func setup()
    
    func setUserId(_ userId: String?)
    func setUserProperty(_ property: AnalyticsUserProperty, to value: AnalyticsParameterValue?)
    
    func registerGlobalProperties(_ properties: AnalyticsParameters)
    func unregisterGlobalProperty(_ property: AnalyticsParameter)
    
    func logScreenView(_ screen: AnalyticsScreen, class screenClass: String, parameters: AnalyticsParameters?)
    func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters)
    func logTransaction(_ transaction: Transaction)
}

public extension AnalyticsProvider {
    func logTransaction(_ transaction: Transaction) {
        logEvent(.appStoreTransaction(transaction), on: nil, additionalParameters: [:])
    }
}
