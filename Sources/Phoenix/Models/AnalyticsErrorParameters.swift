//
//  Copyright © 2026 Hidden Spectrum, LLC. All rights reserved.
//

import CoreData
import Foundation


struct AnalyticsErrorParameters: AnalyticsParametersProvider {
    
    // MARK: Internal
    
    private(set) var analyticsParameters: AnalyticsParameters = [:]
    
    // MARK: Private
    
    private let maximumDepth = 4
    private let maximumNestedErrors = 16
    private let maximumStringLength = 1_024
    
    // MARK: Lifecycle
    
    init(for error: Error) {
        var parameters = details(for: error)
        let nsError = error as NSError
        
        // Preserve the existing fields for dashboards and filters.
        if type(of: error) is NSError.Type,
           let underlying = nsError.userInfo[NSUnderlyingErrorKey] as? NSError {
            parameters[.errorUnderlyingType] = underlying.domain
            parameters[.errorUnderlyingValue] = String(underlying.code)
        }
        
        var nestedErrors: [AnalyticsParameters] = []
        var truncated = false
        appendNestedErrors(of: nsError, depth: 1, parentIndex: nil, to: &nestedErrors, truncated: &truncated)
        
        if !nestedErrors.isEmpty {
            // A JSON string works with providers that only accept scalar log attributes.
            let values = nestedErrors.map { $0.analyticsSupportedValue }
            let data = try? JSONSerialization.data(withJSONObject: values, options: [.sortedKeys])
            parameters[.errorNestedErrors] = data.map { String(decoding: $0, as: UTF8.self) }
        }
        if truncated {
            parameters[.errorDetailsTruncated] = true
        }
        analyticsParameters = parameters
    }
    
    // MARK: Helpers
    
    private func details(for error: Error) -> AnalyticsParameters {
        let nsError = error as NSError
        var details: AnalyticsParameters
        if type(of: error) is NSError.Type {
            details = [
                .errorType: nsError.domain,
                .errorValue: String(nsError.code),
            ]
        } else {
            details = [
                .errorType: String(reflecting: type(of: error)),
                .errorValue: bounded(String(reflecting: error)),
            ]
        }
        if let reason = nsError.localizedFailureReason {
            details[.errorFailureReason] = bounded(reason)
        }
        if let suggestion = nsError.localizedRecoverySuggestion {
            details[.errorRecoverySuggestion] = bounded(suggestion)
        }
        return details
    }
    
    private func appendNestedErrors(
        of error: NSError,
        depth: Int,
        parentIndex: Int?,
        to nestedErrors: inout [AnalyticsParameters],
        truncated: inout Bool
    ) {
        let userInfo = error.userInfo
        let underlying = (userInfo[NSUnderlyingErrorKey] as? Error).map { [$0] } ?? []
        let groups: [(String, [Error])] = [
            (NSUnderlyingErrorKey, underlying),
            (NSMultipleUnderlyingErrorsKey, userInfo[NSMultipleUnderlyingErrorsKey] as? [Error] ?? []),
            (NSDetailedErrorsKey, userInfo[NSDetailedErrorsKey] as? [Error] ?? []),
        ]
        
        for (source, errors) in groups {
            for child in errors {
                guard depth <= maximumDepth, nestedErrors.count < maximumNestedErrors else {
                    truncated = true
                    return
                }
                var childDetails = details(for: child)
                childDetails[AnalyticsParameter("source")] = source
                if let parentIndex {
                    childDetails[AnalyticsParameter("parent_index")] = parentIndex
                }
                let index = nestedErrors.count
                nestedErrors.append(childDetails)
                appendNestedErrors(of: child as NSError, depth: depth + 1, parentIndex: index, to: &nestedErrors, truncated: &truncated)
            }
        }
    }
    
    private func bounded(_ value: String) -> String {
        String(value.prefix(maximumStringLength))
    }
}
