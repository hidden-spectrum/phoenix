//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


struct AnalyticsErrorParameters {
    
    // MARK: Internal
    
    let parameters: AnalyticsParameters
    
    // MARK: Lifecycle
    
    init(for error: Error) {
        if type(of: error) is NSError.Type {
            let nsError = error as NSError
            
            var parameters: AnalyticsParameters = [
                .errorType: nsError.domain,
                .errorValue: String(nsError.code),
            ]
            
            if let underlyingNSError = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
                parameters[.errorUnderlyingType] = underlyingNSError.domain
                parameters[.errorUnderlyingValue] = String(underlyingNSError.code)
            }
            
            self.parameters = parameters
        } else {
            let value = String(reflecting: error)
            
            parameters = [
                .errorType: String(reflecting: type(of: error)),
                .errorValue: value,
            ]
        }
    }
}
