//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsScreen: Equatable, Sendable {
    
    // MARK: Public
    
    public typealias Screen = AnalyticsScreen
    
    public let rawValue: String
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}
