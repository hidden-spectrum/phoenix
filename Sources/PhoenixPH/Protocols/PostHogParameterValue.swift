//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import Phoenix


protocol PostHogParameterValue: AnalyticsParameterValue {
}

extension Array: PostHogParameterValue where Element: PostHogParameterValue {}
extension Bool: PostHogParameterValue {}
extension Date: PostHogParameterValue {}
extension Double: PostHogParameterValue {}
extension Int: PostHogParameterValue {}
extension Int64: PostHogParameterValue {}
extension String: PostHogParameterValue {}


extension AnalyticsParameters {
    func mappedToPostHogParameters() -> [String: Any] {
        let mappedDictionary: [String: Any] = .init(uniqueKeysWithValues: compactMap { key, value in
            guard let value else {
                return nil
            }
            if let value = value.analyticsSupportedValue as? PostHogParameterValue {
                return (key.rawValue, value)
            } else {
                assertionFailure("Value \(String(describing: value)) for key \(key) is not PostHogParameterValue")
                return nil
            }
            
        })
        return mappedDictionary
    }
}
