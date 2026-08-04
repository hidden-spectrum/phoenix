//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation
import StoreKit


public final class TestingAnalyticsProvider: AnalyticsProvider {
    
    // MARK: Internal
    
    var trackedEvents = [EventLog]()
    var trackedScreenViews = [ScreenViewLog]()
    var trackedTransactions = [Transaction]()
    var trackedLogs = [Log]()
    var userId: String?
    var userPropertiesSet = [AnalyticsParameter: AnalyticsParameterValue?]()
    
    // MARK: Lifecycle
    
    public init() {
    }
    
    // MARK: AnalyticsProvider
    
    public func setup() {
    }
    
    public func setUserId(_ userId: String?) {
        self.userId = userId
    }

    public func setUserId(_ userId: String?, userProperties: AnalyticsParameters) {
        self.userId = userId
        setUserProperties(userProperties)
    }
    
    public func setUserProperty(_ property: AnalyticsParameter, to value: AnalyticsParameterValue?) {
        userPropertiesSet[property] = value
    }
    
    public func setUserProperties(_ properties: AnalyticsParameters) {
        for (property, value) in properties {
            userPropertiesSet[property] = value
        }
    }
    
    public func registerGlobalProperties(_ properties: AnalyticsParameters) {
    }
    
    public func unregisterGlobalProperty(_ property: AnalyticsParameter) {
    }
    
    public func logScreenView(_ screen: AnalyticsScreen, class screenClass: String? = nil, parameters: AnalyticsParameters?) {
        trackedScreenViews.append(
            ScreenViewLog(screen: screen, class: screenClass, parameters: parameters ?? [:])
        )
    }
    
    public func logEvent(_ event: AnalyticsEvent, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        trackedEvents.append(
            EventLog(event: event, screen: screen, additionalParameters: additionalParameters)
        )
    }
    
    public func logTransaction(_ transaction: Transaction) {
        trackedTransactions.append(transaction)
    }
    
    public func log(_ level: AnalyticsLogLevel, message: String, on screen: AnalyticsScreen?, additionalParameters: AnalyticsParameters) {
        trackedLogs.append(
            Log(level: level, message: message, screen: screen, additionalParameters: additionalParameters)
        )
    }
    
    // MARK: XCTest
    
    public func removeAllTrackedInfo() {
        trackedEvents.removeAll()
        trackedScreenViews.removeAll()
        trackedLogs.removeAll()
        userPropertiesSet.removeAll()
    }
    
    // MARK: Verification
    
    public func wasEventTracked(_ event: AnalyticsEvent) -> Bool {
        return trackedEvents.first(where: { $0.event == event }) != nil
    }
    
    public func wasScreenViewTracked(_ screen: AnalyticsScreen) -> Bool {
        return trackedScreenViews.first(where: { $0.screen == screen }) != nil
    }
    
    public func findSetValue(for userProperty: AnalyticsParameter) -> AnalyticsParameterValue? {
        if let foundValue = userPropertiesSet[userProperty] {
            return foundValue
        } else {
            return nil
        }
    }
    
    public func wasErrorTracked(_ errorType: String) -> Bool {
        return trackedLogs.contains { log in
            guard case .error = log.level,
                  case let .some(.some(value)) = log.additionalParameters[.errorType] else {
                return false
            }
            return value.analyticsSupportedValue as? String == errorType
        }
    }
}

extension TestingAnalyticsProvider {
    struct EventLog: Equatable, Sendable {
        let event: AnalyticsEvent
        let screen: AnalyticsScreen?
        let additionalParameters: AnalyticsParameters?
        
        static func == (lhs: EventLog, rhs: EventLog) -> Bool {
            lhs.event == rhs.event
            && lhs.screen == rhs.screen
        }
    }
    
    struct ScreenViewLog: Equatable, Sendable {
        let screen: AnalyticsScreen
        let `class`: String?
        let parameters: AnalyticsParameters
        
        static func == (lhs: ScreenViewLog, rhs: ScreenViewLog) -> Bool {
            lhs.screen == rhs.screen
            && lhs.class == rhs.class
            && lhs.parameters == rhs.parameters
        }
    }
    
    struct Log: Sendable {
        let level: AnalyticsLogLevel
        let message: String
        let screen: AnalyticsScreen?
        let additionalParameters: AnalyticsParameters
    }
}
