//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import StoreKit


extension Transaction: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        var params: AnalyticsParameters = [
            .skTransactionEnvironment: environment,
            
            .skTransactionOriginalID: String(originalID),
            .skTransactionOriginalPurchaseDate: originalPurchaseDate,
            
            .skTransactionID: String(id),
            .skTransactionWebLineItemId: webOrderLineItemID,
            
            .skTransactionAppBundleID: appBundleID,
            .skTransactionProductID: productID,
            .skTransactionProductType: productType,
            .skTransactionSubscriptionGroupID: subscriptionGroupID,
            
            .skTransactionPurchaseDate: purchaseDate,
            .skTransactionExpirationDate: expirationDate,
            
            .skTransactionPrice: price,
            .skTransactionCurrencyCode: currency?.identifier,
            
            .skTransactionIsUpgraded: isUpgraded,
            .skTransactionOwnershipType: ownershipType,
            .skPurchasedQuantity: purchasedQuantity,
            
            .skTransactionRevocationDate: revocationDate,
            .skTransactionRevocationReason: revocationReason
        ]
        if #available(iOS 17.2, macOS 14.2, tvOS 17.2, *) {
            params.combine(with: [
                .skTransactionReason: reason,
                .skTransactionOfferId: offer?.id,
                .skTransactionOfferType: offer?.type,
            ])
        }
        return params
    }
}

extension AppStore.Environment: AnalyticsParameterValue {}
extension Product.ProductType: AnalyticsParameterValue {}
extension Transaction.OwnershipType: AnalyticsParameterValue {}
extension Transaction.RevocationReason: AnalyticsParameterValue {}

@available(iOS 17.2, macOS 14.2, tvOS 17.2, *)
extension Transaction.OfferType: AnalyticsParameterValue {}

@available(iOS 17.2, macOS 14.2, tvOS 17.2, *)
extension Transaction.Reason: AnalyticsParameterValue {}


public extension AnalyticsEvent {
    static func appStoreTransaction(_ transaction: Transaction) -> Self {
        Event("app_store_transaction", parameters: transaction.analyticsParameters)
    }
}


public extension AnalyticsParameter {
    
    static let skTransactionEnvironment = Parameter("sk_transaction_environment")
    
    static let skTransactionOriginalID = Parameter("sk_transaction_original_id")
    static let skTransactionOriginalPurchaseDate = Parameter("sk_transaction_original_purchase_date")
    
    static let skTransactionID = Parameter("sk_transaction_id")
    static let skTransactionWebLineItemId = Parameter("sk_transaction_web_line_item_id")
    
    static let skTransactionAppBundleID = Parameter("sk_transaction_app_bundle_id")
    static let skTransactionProductID = Parameter("sk_transaction_product_id")
    static let skTransactionProductType = Parameter("sk_transaction_product_type")
    static let skTransactionSubscriptionGroupID = Parameter("sk_transaction_subscription_group_id")
    
    static let skTransactionPurchaseDate = Parameter("sk_transaction_purchase_date")
    static let skTransactionExpirationDate = Parameter("sk_transaction_expiration_date")
    
    static let skTransactionPrice = Parameter("sk_transaction_price")
    static let skTransactionCurrencyCode = Parameter("sk_transaction_currency_code")
    
    static let skTransactionIsUpgraded = Parameter("sk_transaction_is_upgraded")
    static let skTransactionOwnershipType = Parameter("sk_transaction_ownership_type")
    static let skPurchasedQuantity = Parameter("sk_purchased_quantity")
    
//    static let skSubscriptionState = Parameter("sk_subscription_state") Requires Aynsc
    static let skTransactionReason = Parameter("sk_transaction_reason")
    static let skTransactionOfferId = Parameter("sk_transaction_offer_id")
    static let skTransactionOfferType = Parameter("sk_transaction_offer_type")
    
    static let skTransactionRevocationDate = Parameter("sk_transaction_revoke_date")
    static let skTransactionRevocationReason = Parameter("sk_transaction_revoke_reason")
}
