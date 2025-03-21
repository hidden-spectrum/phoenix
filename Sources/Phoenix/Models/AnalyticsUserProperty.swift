//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsUserProperty: Equatable, Hashable, Sendable {
    
    // MARK: Public
    
    public typealias Property = Self
    
    public let rawValue: String
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
