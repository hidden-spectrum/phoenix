//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import StoreKit


public struct Phoenix: Sendable {
    
    // MARK: Public
    
    public var testing: TestingAnalyticsProvider {
        guard let testingProvider = provider as? TestingAnalyticsProvider else {
            preconditionFailure("Attempting to access testing provider when provider is not set for testing")
        }
        return testingProvider
    }
    
    // MARK: Private
    
    nonisolated(unsafe) private let provider: AnalyticsProvider
    
    // MARK: Lifecycle
    
    public init(provider: AnalyticsProvider) {
        self.provider = provider
    }
    
    public static func stub() -> Self {
        Phoenix(provider: StubAnalyticsProvider())
    }
    
    // MARK: Setup
    
    /// Call this in `AppDelegate.didFinishLaunching`
    public func appDidFinishLaunching() {
        provider.setup()
    }
    
    // MARK: Basic Logging
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String, parameters: AnalyticsParameters? = [:]) {
        provider.logScreenView(screen, class: screenClass, parameters: parameters)
    }
    
    public func logEvent(_ event: AnalyticsEvent, object: AnalyticsParametersProvider? = nil, additionalParameters: AnalyticsParameters = [:]) {
        var allParameters = additionalParameters
        if let object {
            allParameters.combine(with: object.analyticsParameters)
        }
        provider.logEvent(event, additionalParameters: allParameters)
    }
    
    public func logTransaction(_ transaction: Transaction) {
        provider.logTransaction(transaction)
    }
    
    // MARK: Convenience Methods
    
    public func logElementClick(name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue? = nil, parameters: AnalyticsParameters = [:]) {
        logEvent(.clickElement(name: name, type: type, value: value), additionalParameters: parameters)
    }
    
    public func logElementClick(_ element: AnalyticsElement, parameters: AnalyticsParameters = [:]) {
        logEvent(.clickElement(element), additionalParameters: parameters)
    }
    
    public func logElementCopy(_ element: AnalyticsElement, parameters: AnalyticsParameters = [:]) {
        logEvent(.copyElement(element), additionalParameters: parameters)
    }
    
    // MARK: User Properties
    
    public func setUserId(_ userId: String?) {
        provider.setUserId(userId)
    }
    
    public func setUserProperty(_ property: AnalyticsUserProperty, to value: AnalyticsParameterValue?) {
        provider.setUserProperty(property, to: value)
    }
    
    // MARK: Global Properties
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
        provider.registerGlobalProperties(properties)
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
        provider.unregisterGlobalProperty(property)
    }
}
