//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import MetricKit
import OSLog
import StoreKit


public struct Phoenix: Sendable {
    
    // MARK: Private
    
    nonisolated(unsafe) private let provider: AnalyticsProvider
    
    private let log = Logger(subsystem: "io.hspec.phoenix", category: "Phoenix")
    private let userPropertyCache = UserPropertyCache()
    
    // MARK: Lifecycle
    
    public init(provider: AnalyticsProvider) {
        self.provider = provider
    }
    
    public static func stub() -> Self {
        Phoenix(provider: StubAnalyticsProvider())
    }
    
    // MARK: Provider Lifecycle
    
    /// Call this in `AppDelegate.didFinishLaunching` or in @main `init()`
    public func appDidFinishLaunching() {
        provider.setup()
    }
    
    public func flush() {
        provider.flush()
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
        provider.setUserId(userId, userProperties: userPropertyCache.snapshot())
    }
    
    public func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?) {
        let parameters: AnalyticsParameters = [property: value]
        guard userPropertyCache.hasChanges(comparedTo: parameters) else {
            log.debug("No changes to user property, skipping setUserProperty update")
            return
        }
        provider.setUserProperty(property, to: value)
        userPropertyCache.update(with: parameters)
    }
    
    public func setUserProperties(_ properties: AnalyticsParameters) {
        guard userPropertyCache.hasChanges(comparedTo: properties) else {
            log.debug("No changes to user properties, skipping setUserProperties update")
            return
        }
        provider.setUserProperties(properties)
        userPropertyCache.update(with: properties)
    }
    
    // MARK: Global Properties
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
        provider.registerGlobalProperties(properties)
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
        provider.unregisterGlobalProperty(property)
    }
    
    // MARK: Transactions
    
    public func logTransaction(_ transaction: Transaction) {
        provider.logTransaction(transaction)
    }
    
    // MARK: Error & Crash Logging
    
    public func logError(_ error: Error, on screen: AnalyticsScreen? = nil, additionalParameters: AnalyticsParameters = [:], outputTo log: Logger? = nil) {
        if let log {
            var errorText = String(reflecting: error)
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
    
    public func logCrash(_ crashDiagnostic: MXCrashDiagnostic) {
        provider.logCrash(crashDiagnostic)
    }
    
    // MARK: Feature Flags & A/B Testing
    
    public func reloadFeatureFlags() async {
        await provider.reloadFeatureFlags()
    }
    
    public func featureEnabled(_ feature: AnalyticsFeatureFlag) -> Bool {
        provider.featureEnabled(feature)
    }
    
    public func enabledVariant<Variant: AnalyticsExperimentVariant>(for experiment: AnalyticsExperiment<Variant>) -> Variant? {
        provider.enabledVariant(for: experiment)
    }
}
