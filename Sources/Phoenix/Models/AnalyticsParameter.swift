//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct AnalyticsParameter: Sendable {
    
    // MARK: Publict
    
    public typealias Parameter = Self
    
    // MARK: Internal
    
    public let rawValue: String
    
    // MARK: Lifecycle
    
    public init(_ rawValue: String) {
        self.rawValue = rawValue
    }
}

extension AnalyticsParameter: Equatable {
}

extension AnalyticsParameter: Hashable {
}

public extension AnalyticsParameter {
    
    // MARK: General
    
    static let canceled     = Parameter("canceled")
    static let duration     = Parameter("duration")
    static let error        = Parameter("error")
    static let searchTerm   = Parameter("search_term")
    static let success      = Parameter("success")
    static let trigger      = Parameter("trigger")
    static let value        = Parameter("value")
    
    // MARK: Commerce
    
    static let coupon         = Parameter("coupon")
    static let currency       = Parameter("currency")
    static let discount       = Parameter("discount")
    static let paymentType    = Parameter("payment_type")
    static let price          = Parameter("price")
    static let quantity       = Parameter("quantity")
    static let shippingTier   = Parameter("shipping_tier")
    static let shipping       = Parameter("shipping")
    static let tax            = Parameter("tax")
    static let transactionId  = Parameter("transaction_id")
    
    // MARK: Content
    
    static let contentId      = Parameter("content_id")
    static let contentType    = Parameter("content_type")
    static let creativeName   = Parameter("creative_name")
    static let creativeSlot   = Parameter("creative_slot")
    static let promotionId    = Parameter("promotion_id")
    static let promotionName  = Parameter("promotion_name")
    
    // MARK: Interface
    
    static let elementName          = Parameter("element_name")
    static let elementValue         = Parameter("element_value")
    static let elementMetricValue   = Parameter("element_metric_value")
    static let elementType          = Parameter("element_type")
    
    static let presentingElementName = Parameter("presenting_element_name")
    static let presentingElementType = Parameter("presenting_element_type")
    static let presentingScreenName  = Parameter("presenting_screen_name")
    
    // MARK: Error Tracking
    
    static let errorValue           = Parameter("error_value")
    static let errorType            = Parameter("error_type")
}
