//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

@_exported import Phoenix
@_exported import PostHog

import OSLog
import MetricKit
import StoreKit


public final class PostHogAnalyticsProvider: AnalyticsProvider {
    
    // MARK: Private
    
    private let config: PostHogConfig
    private let postHog = PostHogSDK.shared
    
    private let log = Logger(subsystem: "io.hspec.phoenix", category: "PostHogAnalyticsProvider")
    private let userPropertyCache = UserPropertyCache()
    
    private var cachedPersonProperties = AnalyticsParameters()
    private var userId: String? = nil
    
    // MARK: Lifecycle
    
    public init(with config: PostHogConfig) {
        self.config = config
        postHog.setup(config)
    }
    
    // MARK: Provider Lifecycle
    
    public func setup() {
        postHog.reloadFeatureFlags()
    }
    
    public func flush() {
        postHog.flush()
    }
    
    // MARK: User Properties
    
    public func setUserId(_ userId: String?) {
        if let userId {
            postHog.identify(userId)
            self.userId = postHog.getDistinctId()
        }
    }
    
    public func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?) {
        guard let value else {
            postHog.unregister(property.rawValue)
            return
        }
        setUserProperties([property: value])
    }
    
    public func setUserProperties(_ properties: AnalyticsParameters) {
        guard let userId else {
            log.warning("PostHog userId not set, ignoring set user properties")
            return
        }
        
        if !userPropertyCache.hasChanges(comparedTo: properties) {
            log.debug("No changes to user properties, skipping update")
            return
        }
        
        let postHogProperites = properties.mappedToPostHogParameters()
        postHog.identify(userId, userProperties: postHogProperites)
        log.debug("Sent user properties to PostHog: \(postHogProperites)")
        
        userPropertyCache.update(with: properties)
    }
    
    // MARK: Global Properties
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
        postHog.register(properties.mappedToPostHogParameters())
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
        postHog.unregister(property.rawValue)
    }
    
    // MARK: Events
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String? = nil, parameters: AnalyticsParameters?) {
        postHog.screen(screen.rawValue, properties: parameters?.mappedToPostHogParameters() ?? [:])
    }
    
    public func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        let finalParameters = event.parameters
            .combining(with: additionalParameters)
            .combining(with: [.screenName: screen?.rawValue])
            .mappedToPostHogParameters()
        postHog.capture(event.rawValue, properties: finalParameters)
    }
    
    // MARK: Error & Crash Logging
    
    public func logError(_ error: Error, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        let exception: AnalyticsEvent = .exception(
            type: String(describing: type(of: error)),
            value: error.localizedDescription
        )
                                                  
        logEvent(
            exception,
            on: screen,
            additionalParameters: additionalParameters
        )
    }
    
    public func logCrash(_ crash: MXCrashDiagnostic) {
        let exceptionType = crash.exceptionType?.intValue ?? 0
        let exceptionCode = crash.exceptionCode?.intValue ?? 0
        let signal = crash.signal?.intValue ?? 0
        let terminationReason = crash.terminationReason ?? "Unknown Termination"
        
        let errorType = "Signal \(signal)"
        let errorValue = "Termination: \(terminationReason) (Code: \(exceptionCode), Type: \(exceptionType))"
        
        let exception: AnalyticsEvent = .exception(
            type: errorType,
            value: errorValue,
            mechanismType: "MetricKit",
            handled: false,
            stackTraceFrames: crash.callStackTree.toPostHogFrames()
        )
        
        logEvent(exception, on: nil, additionalParameters: [
            .mxCrashVirtualMemoryRegionInfo: crash.virtualMemoryRegionInfo
        ])
    }
    
    // MARK: Feature Flags & A/B Testing
    
    public func reloadFeatureFlags() async {
        await withCheckedContinuation { continuation in
            postHog.reloadFeatureFlags {
                continuation.resume()
            }
        }
    }
    
    public func featureEnabled(_ feature: AnalyticsFeatureFlag) -> Bool {
        postHog.isFeatureEnabled(feature.rawValue)
    }
    
    public func enabledVariant<Variant: AnalyticsExperimentVariant>(for experiment: AnalyticsExperiment<Variant>) -> Variant? {
        guard let rawVariant = postHog.getFeatureFlag(experiment.rawValue) as? String else {
            return nil
        }
        guard let variant = Variant(rawValue: rawVariant) else {
            assertionFailure("Unknown variant '\(rawVariant)' for experiment '\(experiment.rawValue)'")
            return nil
        }
        return variant
    }
}
