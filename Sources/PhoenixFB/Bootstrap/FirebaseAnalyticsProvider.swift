//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import FirebaseCore
import FirebaseAnalytics
import Foundation
import StoreKit


public struct FirebaseAnalyticsProvider: AnalyticsProvider {
    
    // MARK: Internal
    
    let config: Config
    
    // MARK: Lifecycle
    
    public init(with config: Config = Config()) {
        self.config = config
    }
    
    // MARK: AnalyticsProvider
    
    public func setup() {
        #if os(macOS)
        UserDefaults.standard.register( // Needed to work correctly on macOS
            defaults: ["NSApplicationCrashOnExceptions": true]
        )
        #endif
        
        FirebaseApp.configure()
        
        #if DEBUG // Disable logging to GA in DEBUG to avoid messing with live data
        let analyticsDebugEnabled = ProcessInfo.processInfo.arguments.contains("-FIRDebugEnabled")
        Analytics.setAnalyticsCollectionEnabled(analyticsDebugEnabled)
        #else
        Analytics.setAnalyticsCollectionEnabled(true)
        #endif
    }
    
    public func setUserId(_ userId: String?) {
        Analytics.setUserID(userId)
    }
    
    public func setUserProperty(_ property: AnalyticsUserProperty, to value: String?) {
        Analytics.setUserProperty(value, forName: property.rawValue)
    }
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String, parameters: AnalyticsParameters?) {
        var mappedParameters = (parameters ?? [:]).mappedToFirebaseParameters()
        mappedParameters[AnalyticsParameterScreenName] = screen.rawValue
        mappedParameters[AnalyticsParameterScreenClass] = screenClass
        Analytics.logEvent(AnalyticsEventScreenView, parameters: mappedParameters)
    }
    
    public func logEvent(_ event: AnalyticsEvent, additionalParameters: AnalyticsParameters) {
        var finalParameters = event.parameters
            .combining(with: additionalParameters)
        if event.parameters[.value] != nil {
            finalParameters[.currency] = config.itemCurrency
        }
        
        Analytics.logEvent(event.rawValue, parameters: finalParameters.mappedToFirebaseParameters())
    }
    
    public func logTransaction(_ transaction: Transaction) {
        Analytics.logTransaction(transaction)
    }
}

public extension FirebaseAnalyticsProvider {
    
    struct Config {
        
        // MARK: Private
        
        public let itemCurrency: String
        
        // MARK: Lifecycle
        
        public init(itemCurrency: String = "USD") {
            self.itemCurrency = itemCurrency
        }
    }
}
