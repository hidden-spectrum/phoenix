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

    public func snapshot() -> AnalyticsParameters {
        state.withLock { cache in
            cache
        }
    }

    private func snapshot(from cache: AnalyticsParameters, with keys: [AnalyticsParameter]) -> AnalyticsParameters {
        var properties = AnalyticsParameters()
        for key in keys {
            properties[key] = cache[key]
        }
        return properties
    }
    
    public func hasChanges(comparedTo parameters: AnalyticsParameters) -> Bool {
        state.withLock { cache in
            let currentValues = snapshot(from: cache, with: Array(parameters.keys))
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
    
}
