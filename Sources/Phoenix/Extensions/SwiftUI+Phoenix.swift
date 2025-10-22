//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public extension EnvironmentValues {
    @Entry var analyticsPresentationContext: AnalyticsPresentationContext?
    @Entry var analyticsScreen: AnalyticsScreen?
    @Entry var phoenix: Phoenix = Phoenix(provider: StubAnalyticsProvider())
}


@MainActor
public extension Button {
    func analyticsClick(name: AnalyticsElementName, screen: AnalyticsScreen? = nil, parameters: AnalyticsParameters = [:]) -> some View {
        analyticsClick(name: name, type: .button, screen: screen, parameters: parameters)
    }
}

@MainActor
public extension Text {
    func analyticsClick(name: AnalyticsElementName, screen: AnalyticsScreen? = nil, parameters: AnalyticsParameters = [:]) -> some View {
        analyticsClick(name: name, type: .text, screen: screen, parameters: parameters)
    }
}

@MainActor
public extension View {
    func analyticsPresentationContext(elementName: AnalyticsElementName? = nil, elementType: AnalyticsElementType? = nil, screen: AnalyticsScreen? = nil) -> some View {
        analyticsPresentationContext(
            AnalyticsPresentationContext(
                elementName: elementName,
                elementType: elementType,
                screen: screen
            )
        )
    }
    
    func analyticsPresentationContext(_ context: AnalyticsPresentationContext? = nil) -> some View {
        environment(\.analyticsPresentationContext, context)
    }
}
