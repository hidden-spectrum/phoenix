//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

@_exported import Phoenix
@_exported import PostHog

import OSLog
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
    
    // MARK: AnalyticsProvider
    
    public func setup() {
        postHog.reloadFeatureFlags()
    }
    
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
        postHog.identify(userId, userProperties: properties.mappedToPostHogParameters())
    }
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
        postHog.register(properties.mappedToPostHogParameters())
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
        postHog.unregister(property.rawValue)
    }
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String, parameters: AnalyticsParameters?) {
        postHog.screen(screen.rawValue, properties: parameters?.mappedToPostHogParameters() ?? [:])
    }
    
    public func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        let finalParameters = event.parameters
            .combining(with: additionalParameters)
            .combining(with: [.screenName: screen?.rawValue])
            .mappedToPostHogParameters()
        postHog.capture(event.rawValue, properties: finalParameters)
    }
    
    public func logError(_ error: Error, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        let exception: AnalyticsParameters = [
            .type: String(describing: type(of: error)),
            .value: error.localizedDescription,
        ]
        let errorParameters: AnalyticsParameters = [
            .exceptionList: [exception]
        ]
                                                  
        logEvent(
            .exception,
            on: screen,
            additionalParameters: errorParameters.combining(with: additionalParameters)
        )
    }
}
