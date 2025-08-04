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
}


public func ==(lhs: AnalyticsParameters, rhs: AnalyticsParameters) -> Bool {
    guard lhs.count == rhs.count, lhs.keys == rhs.keys else {
        return false
    }
    
    for key in lhs.keys {
        switch (lhs[key], rhs[key]) {
        case (.none, .none): // Both values are nil
            continue
        case let (.some(lhsValue), .some(rhsValue)): // Both values are non-nil
            if lhsValue == nil && rhsValue == nil {
                continue
            }
            if !areEqual(lhsValue as Any, rhsValue as Any) {
                return false
            }
        default: // One is nil and the other is not
            return false
        }
    }
    
    return true
}
