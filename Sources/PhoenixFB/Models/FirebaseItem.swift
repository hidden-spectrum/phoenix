//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Foundation


public struct FirebaseItem {
    
    // MARK: Public
    
    public let id: String
    public let name: String
    
    public var affiliation: String?
    public var brand: String?
    public var categories: [String]? // Max 5
    public var coupon: String?
    public var discount: Double?
    public var index: Int?
    public var locationId: String?
    public var listId: String?
    public var listName: String?
    public var price: Double?
    public var quantity: Int?
    public var variant: String?
    
    // MARK: Lifecycle
    
    public init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

extension FirebaseItem: AnalyticsParametersProvider {
    public var analyticsParameters: AnalyticsParameters {
        var parameters: AnalyticsParameters = [
            .affiliation: affiliation,
            .coupon: coupon,
            .discount: discount,
            .index: index,
            .itemId: id,
            .itemName: name,
            .itemBrand: brand,
            .itemListId: listId,
            .itemListName: listName,
            .itemVariant: variant,
            .locationId: locationId,
            .price: price,
            .quantity: quantity
        ]
        for (index, category) in (categories ?? []).prefix(5).enumerated() {
            switch index {
            case 0: parameters[.itemCategory] = category
            case 1: parameters[.itemCategory2] = category
            case 2: parameters[.itemCategory3] = category
            case 3: parameters[.itemCategory4] = category
            case 4: parameters[.itemCategory5] = category
            default: break
            }
        }
        return parameters
    }
}


public extension AnalyticsParameter {
    
    // MARK: Item Parameters
    
    static let items          = Parameter("items")
    
    static let itemId         = Parameter("item_id")
    static let itemName       = Parameter("item_name")
    static let itemBrand      = Parameter("item_brand")
    static let itemCategory   = Parameter("item_category")
    static let itemCategory2  = Parameter("item_category2")
    static let itemCategory3  = Parameter("item_category3")
    static let itemCategory4  = Parameter("item_category4")
    static let itemCategory5  = Parameter("item_category5")
    static let itemListId     = Parameter("item_list_id")
    static let itemListName   = Parameter("item_list_name")
    static let itemVariant    = Parameter("item_variant")
}
