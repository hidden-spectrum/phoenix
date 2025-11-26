//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import OSLog
import StoreKit


public struct Phoenix: Sendable {
    
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
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String? = nil, parameters: AnalyticsParameters? = [:]) {
        provider.logScreenView(screen, class: screenClass, parameters: parameters)
    }
    
    public func logEvent(
        _ event: AnalyticsEvent,
        on screen: AnalyticsScreen? = nil,
        object: AnalyticsParametersProvider? = nil,
        additionalParameters: AnalyticsParameters = [:]
    ) {
        var allParameters = additionalParameters
        if let object {
            allParameters.combine(with: object.analyticsParameters)
        }
        provider.logEvent(event, on: screen, additionalParameters: allParameters)
    }
    
    public func logTransaction(_ transaction: Transaction) {
        provider.logTransaction(transaction)
    }
    
    // MARK: Convenience Methods
    
    public func logElementClick(
        name: AnalyticsElementName,
        type: AnalyticsElementType,
        value: AnalyticsParameterValue? = nil,
        on screen: AnalyticsScreen? = nil,
        parameters: AnalyticsParameters = [:]
    ) {
        logEvent(
            .elementClick(name: name, type: type, value: value),
            on: screen,
            additionalParameters: parameters
        )
    }
    
    public func logElementClick(
        _ element: AnalyticsElement,
        on screen: AnalyticsScreen? = nil,
        parameters: AnalyticsParameters = [:]
    ) {
        logEvent(.elementClick(element), on: screen, additionalParameters: parameters)
    }
    
    public func logElementCopy(
        _ element: AnalyticsElement,
        on screen: AnalyticsScreen? = nil,
        parameters: AnalyticsParameters = [:]
    ) {
        logEvent(.elementCopy(element), on: screen, additionalParameters: parameters)
    }
    
    // MARK: User Properties
    
    public func setUserId(_ userId: String?) {
        provider.setUserId(userId)
    }
    
    public func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?) {
        provider.setUserProperty(property, to: value)
    }
    
    public func setUserProperties(_ properties: AnalyticsParameters) {
        provider.setUserProperties(properties)
    }
    
    // MARK: Global Properties
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
        provider.registerGlobalProperties(properties)
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
        provider.unregisterGlobalProperty(property)
    }
    
    // MARK: Error & Crash Logging
    
    public func logError(_ error: Error, on screen: AnalyticsScreen? = nil, additionalParameters: AnalyticsParameters = [:], outputTo log: Logger? = nil) {
        if let log {
            var errorText = error.localizedDescription
            if let screen {
                errorText += "\nAnalyticsScreen: \(screen.rawValue)"
            }
            if !additionalParameters.isEmpty {
                errorText += "\nAdditional Params: \(additionalParameters)"
            }
            log.error("\(errorText)")
        }
        provider.logError(error, on: screen, additionalParameters: additionalParameters)
    }
}
