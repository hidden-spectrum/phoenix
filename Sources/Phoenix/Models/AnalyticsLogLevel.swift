//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//


public enum AnalyticsLogLevel: Sendable {
    
    /// Finest-grained tracing detail.
    case trace
    
    /// Diagnostic information useful while debugging.
    case debug
    
    /// Informational messages and general logs.
    case info
    
    /// Warning messages indicating potential issues or deprecation notices.
    case warning
    
    /// Error messages indicating failures or critical issues.
    case error
    
    /// An unrecoverable failure; the app likely cannot continue.
    case fatal
}
