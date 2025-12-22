//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import os


public final class UserPropertyCache: Sendable {
    
    // MARK: Private
    
    private let state = OSAllocatedUnfairLock(initialState: AnalyticsParameters())
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    // MARK: Updates
    
    public func hasChanges(comparedTo parameters: AnalyticsParameters) -> Bool {
        state.withLock { cache in
            let currentValues = getCachedProperties(from: cache, with: Array(parameters.keys))
            if currentValues == parameters {
                return false
            } else {
                return true
            }
        }
    }
    
    public func update(with parameters: AnalyticsParameters) {
        state.withLock { cache in
            for (key, value) in parameters {
                cache[key] = value
            }
        }
    }
    
    private func getCachedProperties(from cache: AnalyticsParameters, with keys: [AnalyticsParameter]) -> AnalyticsParameters {
        var properties = AnalyticsParameters()
        for key in keys {
            properties[key] = cache[key]
        }
        return properties
    }
}
