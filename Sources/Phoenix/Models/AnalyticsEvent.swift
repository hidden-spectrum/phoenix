//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsEvent: Sendable {
    
    // MARK: Public
    
    public typealias Event = Self
    
    // MARK: Internal
    
    public let parameters: AnalyticsParameters
    public let rawValue: String
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String, parameters: AnalyticsParameters = [:]) {
        self.parameters = parameters
        self.rawValue = rawValue
    }
}

extension AnalyticsEvent {
    
    // MARK: Standard
    
    static func clickElement(name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue?) -> Self {
        elementAction("click_element", name: name, type: type, value: value)
    }
    
    static func copyElement(name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue?) -> Self {
        elementAction("copy_element", name: name, type: type, value: value)
    }
    
    static func elementAction(_ eventName: String, name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue?) -> Self {
        var parameters: AnalyticsParameters = [
            .elementName: name,
            .elementType: type
        ]
        if let metricValue = value as? AnalyticsMetricValue {
            parameters[.elementMetricValue] = metricValue
        } else {
            parameters[.elementValue] = value
        }
        return Event(eventName, parameters: parameters)
    }
    
    // MARK: Convenience
    
    static func clickElement(_ element: AnalyticsElement) -> Self {
        clickElement(name: element.analyticsName, type:  element.analyticsType, value: element.analyticsValue)
    }
    
    static func copyElement(_ element: AnalyticsElement) -> Self {
        copyElement(name: element.analyticsName, type: element.analyticsType, value: element.analyticsValue)
    }
}

extension AnalyticsEvent: Equatable {
    public static func == (lhs: AnalyticsEvent, rhs: AnalyticsEvent) -> Bool {
        lhs.rawValue == rhs.rawValue
        && lhs.parameters == rhs.parameters
    }
}
