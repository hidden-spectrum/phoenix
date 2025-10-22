//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import SwiftUI


public struct AnalyticsTrackingButton<Label: View>: View {
    
    // MARK: Private
    
    @Environment(\.analyticsScreen) private var screen
    @Environment(\.phoenix) private var phoenix
    
    private let action: () -> Void
    private let label: () -> Label
    private let name: AnalyticsElementName
    
    // MARK: Lifecycle
    
    init(name: AnalyticsElementName, action: @escaping () -> Void, label: @escaping () -> Label) {
        self.name = name
        self.action = action
        self.label = label
    }
    
    // MARK: View
    
    public var body: some View {
        Button(
            action: {
                action()
                phoenix.logElementClick(name: name, type: .button, on: screen)
            }, label: {
                label()
            }
        )
    }
}
