//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import SwiftUI


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
