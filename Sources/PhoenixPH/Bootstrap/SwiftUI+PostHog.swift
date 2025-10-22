//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix
import PostHog
import SwiftUI


public extension View {
    func analyticsScreen(_ screen: AnalyticsScreen, parameters: AnalyticsParameters = [:]) -> some View {
        modifier(PHAnalyticsScreenViewModifier(screen: screen, parameters: parameters))
    }
}


struct PHAnalyticsScreenViewModifier: ViewModifier {
    
    // MARK: Private
    
    @Environment(\.analyticsPresentationContext) private var context
    
    private let screen: AnalyticsScreen
    private let parameters: AnalyticsParameters
    
    private var finalParameters: AnalyticsParameters {
        var mergedParameters = parameters
        if let context {
            mergedParameters.combine(with: context.analyticsParameters)
        }
        return mergedParameters
    }
    
    // MARK: Lifecycle
    
    init(screen: AnalyticsScreen, parameters: AnalyticsParameters) {
        self.screen = screen
        self.parameters = parameters
    }
    
    // MARK: ViewModifier
    
    public func body(content: Content) -> some View {
        content
            .postHogScreenView(screen.rawValue, finalParameters.mappedToPostHogParameters())
            .environment(\.analyticsScreen, screen)
    }
}
