//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix
import PostHog
import SwiftUI


public extension View {
    func analyticsScreen(_ screen: AnalyticsScreen, parameters: AnalyticsParameters = [:]) -> some View {
        self.postHogScreenView(screen.rawValue, parameters.mappedToPostHogParameters())
            .environment(\.analyticsScreen, screen)
    }
}
