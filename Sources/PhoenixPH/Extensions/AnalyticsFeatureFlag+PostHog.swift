//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import Phoenix


extension AnalyticsFeatureFlag where Value: Decodable {
    func decodePayload(_ payload: Any?) -> Value? {
        guard let payload, let data = try? JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed) else {
            return nil
        }
        return try? JSONDecoder().decode(Value.self, from: data)
    }
}
