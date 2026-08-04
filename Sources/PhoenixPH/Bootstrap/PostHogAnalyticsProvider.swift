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
        setUserId(userId, userProperties: [:])
    }

    public func setUserId(_ userId: String?, userProperties: AnalyticsParameters) {
        guard let userId else {
            return
        }
        let postHogProperties = userProperties.mappedToPostHogParameters()
        if postHogProperties.isEmpty {
            postHog.identify(userId)
        } else {
            postHog.identify(userId, userProperties: postHogProperties)
        }
        self.userId = postHog.getDistinctId()
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
            log.warning("PostHog userId not set, user properties will be replayed on setUserId")
            return
        }
        let postHogProperties = properties.mappedToPostHogParameters()
        postHog.identify(userId, userProperties: postHogProperties)
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
    
    public func log(_ level: AnalyticsLogLevel, message: String, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        let attributes = additionalParameters
            .combining(with: [.logScreenName: screen?.rawValue])
            .mappedToPostHogParameters()
        postHog.captureLog(message, level: level.postHogLevel, attributes: attributes)
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
