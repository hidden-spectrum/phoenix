//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public typealias AnalyticsParameters = [AnalyticsParameter: AnalyticsParameterValue?]

public extension AnalyticsParameters {
    func combining(with otherParameters: AnalyticsParameters?) -> Self {
        guard let otherParameters else {
            return self
        }
        return merging(otherParameters) { _, new in new }
    }
    
    mutating func combine(with otherParameters: AnalyticsParameters?) {
        self = combining(with: otherParameters)
    }
    
    func mappedToAnalyticsParameters() -> [String: Any] {
        let mappedDictionary: [String: Any] = .init(uniqueKeysWithValues: compactMap { key, value in
            guard let value else {
                return nil
            }
            return (key.rawValue, value.analyticsSupportedValue)
        })
        return mappedDictionary
    }
}

extension AnalyticsParameters: AnalyticsParameterValue {
    public var analyticsSupportedValue: AnalyticsSupportedParameterValue {
        let mappedDictionary: [String: AnalyticsSupportedParameterValue] = .init(uniqueKeysWithValues: compactMap { key, value in
            guard let value else {
                return nil
            }
            return (key.rawValue, value.analyticsSupportedValue)
        })
        return mappedDictionary
    }
}

 
public func ==(lhs: AnalyticsParameters, rhs: AnalyticsParameters) -> Bool {
    guard lhs.keys == rhs.keys else { return false }
    
    for key in lhs.keys {
        switch (lhs[key], rhs[key]) {
        case (.none, .none): // Both values are nil
            continue
        case let (.some(lhsValue), .some(rhsValue)): // Both values are non-nil
            if lhsValue == nil && rhsValue == nil {
                continue
            }
            
            guard let lhsValue = lhsValue, let rhsValue = rhsValue else {
                return false
            }
            if !lhsValue.analyticsSupportedValue.isEqualTo(rhsValue.analyticsSupportedValue) {
                return false
            }
        default: // One is nil and the other is not
            return false
        }
    }
    
    return true
}
