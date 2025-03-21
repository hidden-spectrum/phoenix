//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public extension EnvironmentValues {
    @Entry var phoenix: Phoenix = Phoenix(provider: StubAnalyticsProvider())
}


@MainActor
public extension Button {
    func logClick(using phoenix: Phoenix, name: AnalyticsElementName, parameters: AnalyticsParameters = [:]) -> some View {
        logClick(using: phoenix, name: name, type: .button, parameters: parameters)
    }
}

@MainActor
public extension Text {
    func logClick(using phoenix: Phoenix, name: AnalyticsElementName, parameters: AnalyticsParameters = [:]) -> some View {
        logClick(using: phoenix, name: name, type: .text, parameters: parameters)
    }
}

@MainActor
public extension View {
    func logClick(using phoenix: Phoenix, name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue? = nil, parameters: AnalyticsParameters = [:]) -> some View {
        simultaneousGesture(
            TapGesture().onEnded { _ in
                phoenix.logElementClick(name: name, type: type, value: value, parameters: parameters)
            }
        )
    }
}
