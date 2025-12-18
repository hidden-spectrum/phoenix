//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public struct AnalyticsTrackingButton<Label: View>: View {
    
    // MARK: Private
    
    @Environment(\.analyticsScreen) private var screen
    @Environment(\.phoenix) private var phoenix
    
    private let name: AnalyticsElementName
    private let type: AnalyticsElementType
    private let parameters: AnalyticsParameters
    
    private let action: () -> Void
    private let label: Label
    
    // MARK: Lifecycle
    
    public init(
        name: AnalyticsElementName,
        type: AnalyticsElementType = .button,
        parameters: AnalyticsParameters = [:],
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.name = name
        self.type = type
        self.parameters = parameters
        
        self.action = action
        self.label = label()
    }
    
    // MARK: View
    
    public var body: some View {
        Button(
            action: {
                action()
                phoenix.logElementClick(name: name, type: type, on: screen, parameters: parameters)
            }, label: {
                label
            }
        )
    }
}
