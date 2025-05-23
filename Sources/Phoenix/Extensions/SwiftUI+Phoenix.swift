//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public extension EnvironmentValues {
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
    func analyticsClick(
        name: AnalyticsElementName,
        type: AnalyticsElementType,
        value: AnalyticsParameterValue? = nil,
        screen: AnalyticsScreen? = nil,
        parameters: AnalyticsParameters = [:]
    ) -> some View {
        modifier(
            AnalyticsClickViewModifier(name: name, type: type, value: value, screen: screen, parameters: parameters)
        )
    }
}


struct AnalyticsClickViewModifier: ViewModifier {
    
    // MARK: Private
    
    @Environment(\.analyticsScreen) private var screen
    @Environment(\.phoenix) private var phoenix
    
    private let name: AnalyticsElementName
    private let type: AnalyticsElementType
    private let value: AnalyticsParameterValue?
    private let parameters: AnalyticsParameters
    private let screenOverride: AnalyticsScreen?
    
    // MARK: Lifecycle
    
    init(
        name: AnalyticsElementName,
        type: AnalyticsElementType,
        value: AnalyticsParameterValue? = nil,
        screen: AnalyticsScreen? = nil,
        parameters: AnalyticsParameters = [:]
    ) {
        self.name = name
        self.type = type
        self.value = value
        self.screenOverride = screen
        self.parameters = parameters
    }
    
    // MARK: ViewModifier
    
    public func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    phoenix.logElementClick(
                        name: name,
                        type: type,
                        value: value,
                        on: screenOverride ?? screen,
                        parameters: parameters,
                    )
                }
            )
    }
}
