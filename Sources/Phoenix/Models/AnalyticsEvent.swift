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
    
    package static func error(_ error: Error) -> Event {
        var parameters: AnalyticsParameters
        
        if type(of: error) is NSError.Type {
            let nsError = error as NSError
            
            parameters = [
                .errorType: nsError.domain,
                .errorValue: String(nsError.code),
            ]
            
            if let underlyingNSError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                parameters[.errorUnderlyingType] = underlyingNSError.domain
                parameters[.errorUnderlyingValue] = String(underlyingNSError.code)
            }
        } else {
            parameters = [
                .errorType: String(reflecting: type(of: error)),
                .errorValue: String(reflecting: error),
            ]
        }
        
        return Event("error", parameters: parameters)
    }
    
    static func elementClick(name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue?) -> Self {
        elementAction("element_click", name: name, type: type, value: value)
    }
    
    static func elementCopy(name: AnalyticsElementName, type: AnalyticsElementType, value: AnalyticsParameterValue?) -> Self {
        elementAction("element_copy", name: name, type: type, value: value)
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
    
    static func elementClick(_ element: AnalyticsElement) -> Self {
        elementClick(name: element.analyticsName, type:  element.analyticsType, value: element.analyticsValue)
    }
    
    static func elementCopy(_ element: AnalyticsElement) -> Self {
        elementCopy(name: element.analyticsName, type: element.analyticsType, value: element.analyticsValue)
    }
}

extension AnalyticsEvent: Equatable {
    public static func == (lhs: AnalyticsEvent, rhs: AnalyticsEvent) -> Bool {
        lhs.rawValue == rhs.rawValue
        && lhs.parameters == rhs.parameters
    }
}
