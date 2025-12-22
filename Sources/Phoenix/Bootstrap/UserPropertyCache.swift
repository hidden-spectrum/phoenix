//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//


public final class UserPropertyCache {
    
    // MARK: Private
    
    private var cache = AnalyticsParameters()
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    // MARK: Updates
    
    public func hasChanges(comparedTo parameters: AnalyticsParameters) -> Bool {
        let currentValues = getCachedProperties(with: Array(parameters.keys))
        if currentValues == parameters {
            return false
        } else {
            return true
        }
    }
    
    public func update(with parameters: AnalyticsParameters) {
        for (key, value) in parameters {
            cache[key] = value
        }
    }
    
    private func getCachedProperties(with keys: [AnalyticsParameter]) -> AnalyticsParameters {
        var properties = AnalyticsParameters()
        for key in keys {
            properties[key] = cache[key]
        }
        return properties
    }
}
