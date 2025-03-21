//
//  Copyright © 2025 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix


public extension AnalyticsEvent {
    
    // MARK: Auth
    
    static func login(method: String?) -> Self {
        Event(AnalyticsEventLogin, parameters: [
            .method: method
        ])
    }
    
    static func signUp(method: String?) -> Self {
        Event(AnalyticsEventSignUp, parameters: [
            .method: method
        ])
    }
    
    // MARK: Commerce
    
    static func generateLead(value: Double) -> Self {
        Event(AnalyticsEventGenerateLead, parameters: [
            .value: value
        ])
    }
    
    static func addPaymentInfo(value: Double, coupon: String? = nil, paymentType: String? = nil, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventAddPaymentInfo, parameters: [
            .value: value,
            .coupon: coupon,
            .paymentType: paymentType,
            .items: items
        ])
    }
    
    static func addShippingInfo(value: Double, coupon: String? = nil, shippingTier: String? = nil, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventAddShippingInfo, parameters: [
            .value: value,
            .coupon: coupon,
            .shippingTier: shippingTier,
            .items: items
        ])
    }
    
    static func addToCart(value: Double, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventAddToCart, parameters: [
            .value: value,
            .items: items
        ])
    }
    
    static func removeFromCart(value: Double, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventRemoveFromCart, parameters: [
            .value: value,
            .items: items
        ])
    }
    
    static func viewCart(value: Double, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventViewCart, parameters: [
            .value: value,
            .items: items
        ])
    }
    
    static func viewItem(value: Double, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventViewItem, parameters: [
            .value: value,
            .items: items
        ])
    }
    
    static func viewItemList(id: String?, name: String?, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventViewItemList, parameters: [
            .itemListId: id,
            .itemListName: name,
            .items: items
        ])
    }
    
    static func addToWishlist(value: Double, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventAddToWishlist, parameters: [
            .value: value,
            .items: items
        ])
    }
    
    static func beginCheckout(value: Double, coupon: String? = nil, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventBeginCheckout, parameters: [
            .value: value,
            .coupon: coupon,
            .items: items
        ])
    }
    
    static func purchase(transactionId: String, value: Double, coupon: String? = nil, shipping: Double? = nil, tax: Double? = nil, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventPurchase, parameters: [
            .transactionId: transactionId,
            .value: value,
            .coupon: coupon,
            .shipping: shipping,
            .tax: tax,
            .items: items
        ])
    }
    
    static func refund(transactionId: String, value: Double, coupon: String? = nil, shipping: Double? = nil, tax: Double? = nil, items: [AnalyticsItem]) -> Self {
        Event(AnalyticsEventRefund, parameters: [
            .transactionId: transactionId,
            .value: value,
            .coupon: coupon,
            .shipping: shipping,
            .tax: tax,
            .items: items
        ])
    }
    
    // MARK: Content
    
    static func search(term: String) -> Self {
        Event(AnalyticsEventSearch, parameters: [
            .searchTerm: term
        ])
    }
    
    static func selectContent(id: String?, type: String? = nil) -> Self {
        Event(AnalyticsEventSelectContent, parameters: [
            .contentId: id,
            .contentType: type
        ])
    }
    
    static func selectItem(items: [AnalyticsItem], listId: String? = nil, listName: String? = nil) -> Self {
        Event(AnalyticsEventSelectItem, parameters: [
            .items: items,
            .itemListId: listId,
            .itemListName: listName
        ])
    }
    
    static func viewPromotion(name: String?, slot: String? = nil, promotionId: String? = nil, promotionName: String? = nil, items: [AnalyticsItem]? = nil) -> Self {
        Event(AnalyticsEventViewPromotion, parameters: [
            .creativeName: name,
            .creativeSlot: slot,
            .promotionId: promotionId,
            .promotionName: promotionName,
            .items: items
        ])
    }
    
    static func selectPromotion(name: String?, slot: String? = nil, promotionId: String? = nil, promotionName: String? = nil, items: [AnalyticsItem]? = nil) -> Self {
        Event(AnalyticsEventSelectPromotion, parameters: [
            .creativeName: name,
            .creativeSlot: slot,
            .promotionId: promotionId,
            .promotionName: promotionName,
            .items: items
        ])
    }
    
    static func share(method: String?, contentType: String? = nil, itemId: String? = nil) -> Self {
        Event(AnalyticsEventShare, parameters: [
            .method: method,
            .contentType: contentType,
            .itemId: itemId
        ])
    }
    
    static let tutorialBegin = Event(AnalyticsEventTutorialBegin)
    
    static let tutorialComplete = Event(AnalyticsEventTutorialComplete)
    
    // MARK: Gaming
    
    static func joinGroup(id: String?) -> Self {
        Event(AnalyticsEventJoinGroup, parameters: [
            .groupId: id
        ])
    }
    
    static func levelStart(name: String?) -> Self {
        Event(AnalyticsEventLevelStart, parameters: [
            .levelName: name
        ])
    }
    
    static func levelEnd(name: String?, success: Bool?) -> Self {
        Event(AnalyticsEventLevelEnd, parameters: [
            .levelName: name,
            .success: success
        ])
    }
    
    static func levelUp(level: Int?, character: String? = nil) -> Self {
        Event(AnalyticsEventLevelUp, parameters: [
            .level: level,
            .character: character
        ])
    }
    
    static func postScore(score: Double, level: Int?, character: String? = nil) -> Self {
        Event(AnalyticsEventPostScore, parameters: [
            .score: score,
            .level: level,
            .character: character
        ])
    }
    
    static func unlockAchievement(id: String) -> Self {
        Event(AnalyticsEventUnlockAchievement, parameters: [
            .achievementId: id
        ])
    }
    
    static func earnVirtualCurrency(name: String?, value: Double?) -> Self {
        Event(AnalyticsEventEarnVirtualCurrency, parameters: [
            .virtualCurrencyName: name,
            .value: value
        ])
    }
    
    static func spendVirtualCurrency(value: Double, name: String, itemName: String) -> Self {
        Event(AnalyticsEventSpendVirtualCurrency, parameters: [
            .value: value,
            .virtualCurrencyName: name,
            .itemName: itemName
        ])
    }
}
