//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

@_exported import Phoenix
@_exported import PostHog

import StoreKit


public final class PostHogAnalyticsProvider: AnalyticsProvider {
    
    // MARK: Private
    
    private let config: PostHogConfig
    private let postHog = PostHogSDK.shared
    
    private var userId: String?
    
    // MARK: Lifecycle
    
    public init(with config: PostHogConfig) {
        self.config = config
        self.userId = nil
        postHog.setup(config)
    }
    
    // MARK: AnalyticsProvider
    
    public func setup() {
        postHog.reloadFeatureFlags()
    }
    
    public func setUserId(_ userId: String?) {
        if let userId {
            postHog.identify(userId)
            self.userId = userId
        }
    }
    
    public func setUserProperty(_ property: AnalyticsUserProperty, to value: AnalyticsParameterValue?) {
        guard let value = value?.analyticsSupportedValue as? PostHogParameterValue else {
            assertionFailure("Unsupported value type for PostHog: \(String(describing: value))")
            return
        }
        let userId = userId ?? postHog.getDistinctId()
        postHog.identify(userId, userProperties: [property.rawValue: value])
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
    
    public func logEvent(_ event: AnalyticsEvent, additionalParameters: AnalyticsParameters) {
        let finalParameters = event.parameters
            .combining(with: additionalParameters)
        postHog.capture(event.rawValue, properties: finalParameters.mappedToPostHogParameters())
    }
}
