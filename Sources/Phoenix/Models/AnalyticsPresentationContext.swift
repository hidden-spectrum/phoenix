//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsPresentationContext: Sendable {
    
    // MARK: Public
    
    public let elementName: AnalyticsElementName?
    public let elementType: AnalyticsElementType?
    public let screen: AnalyticsScreen?
    
    // MARK: Lifecycle
    
    public init(
        elementName: AnalyticsElementName? = nil,
        elementType: AnalyticsElementType? = nil,
        screen: AnalyticsScreen? = nil
    ) {
        self.elementName = elementName
        self.elementType = elementType
        self.screen = screen
        
    }
}

extension AnalyticsPresentationContext: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        [
            .presentingElementName: elementName,
            .presentingElementType: elementType,
            .presentingScreenName: screen
        ]
    }
}
