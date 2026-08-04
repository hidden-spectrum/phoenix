//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//


public protocol AnalyticsLoggableError: Error {
    var analyticsLogMessage: String { get }
}
