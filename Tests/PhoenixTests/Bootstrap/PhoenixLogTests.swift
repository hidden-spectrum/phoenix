//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

@testable import Phoenix

import Testing


@Suite("Phoenix Log Tests")
struct PhoenixLogTests {
    
    private enum NativeError: Error {
        case failure
    }
    
    private enum LoggableError: AnalyticsLoggableError {
        case failure
        
        var analyticsLogMessage: String {
            "Loggable failure"
        }
    }
    
    private let phoenix: Phoenix
    private let provider: TestingAnalyticsProvider
    private let screen = AnalyticsScreen("test_screen")
    
    init() {
        let provider = TestingAnalyticsProvider()
        self.provider = provider
        phoenix = Phoenix(provider: provider)
    }
    
    @Test("Generic logs forward level, message, screen, and parameters")
    func genericLog() throws {
        let parameters: AnalyticsParameters = [.contentType: "test_content"]
        phoenix.log(.warning, "Test warning", on: screen, additionalParameters: parameters)
        
        let log = try #require(provider.trackedLogs.first)
        guard case .warning = log.level else {
            Issue.record("Expected warning log level")
            return
        }
        #expect(provider.trackedLogs.count == 1)
        #expect(log.message == "Test warning")
        #expect(log.screen == screen)
        #expect(log.additionalParameters == parameters)
    }
    
    @Test("Error logs add reflected error parameters and use the error level")
    func errorLog() throws {
        let error = NativeError.failure
        let additionalParameters: AnalyticsParameters = [.contentType: "test_content"]
        phoenix.log(error, "Test failure", on: screen, additionalParameters: additionalParameters)
        let expectedParameters: AnalyticsParameters = [
            .contentType: "test_content",
            .errorType: String(reflecting: type(of: error)),
            .errorValue: String(reflecting: error),
        ]
        
        let log = try #require(provider.trackedLogs.first)
        guard case .error = log.level else {
            Issue.record("Expected error log level")
            return
        }
        #expect(provider.trackedLogs.count == 1)
        #expect(log.message == "Test failure")
        #expect(log.screen == screen)
        #expect(log.additionalParameters == expectedParameters)
    }
    
    @Test("AnalyticsLoggableError uses its analytics log message")
    func loggableError() throws {
        let error = LoggableError.failure
        phoenix.log(error, on: screen)
        let expectedParameters: AnalyticsParameters = [
            .errorType: String(reflecting: type(of: error)),
            .errorValue: String(reflecting: error),
        ]
        
        let log = try #require(provider.trackedLogs.first)
        guard case .error = log.level else {
            Issue.record("Expected error log level")
            return
        }
        #expect(provider.trackedLogs.count == 1)
        #expect(log.message == "Loggable failure")
        #expect(log.screen == screen)
        #expect(log.additionalParameters == expectedParameters)
    }
}
