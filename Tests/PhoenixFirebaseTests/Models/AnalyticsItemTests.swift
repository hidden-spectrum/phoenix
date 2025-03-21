//
//  Copyright © 2023 Hidden Spectrum, LLC. All rights reserved.
//

import Phoenix
import Testing


@Suite("AnalyticsItem Tests")
struct AnalyticsItemTests {
    
    func testInitAnalyticsItem() {
        let item = AnalyticsItem(id: "123", name: "TestItem")
        #expect(item.id == "123")
        #expect(item.name == "TestItem")
    }
    
    func testAnalyticsParameters_withAllNil() {
        let item = AnalyticsItem(id: "123", name: "TestItem")
        let parameters = item.analyticsParameters
        #expect(parameters[.affiliation] == nil)
        #expect(parameters[.coupon] == nil)
        #expect(parameters[.discount] == nil)
        #expect(parameters[.index] == nil)
        #expect(parameters[.itemBrand] == nil)
        #expect(parameters[.itemListId] == nil)
        #expect(parameters[.itemListName] == nil)
        #expect(parameters[.itemVariant] == nil)
        #expect(parameters[.locationId] == nil)
        #expect(parameters[.price] == nil)
        #expect(parameters[.quantity] == nil)
        #expect(parameters[.itemCategory] == nil)
        #expect(parameters[.itemCategory2] == nil)
        #expect(parameters[.itemCategory3] == nil)
        #expect(parameters[.itemCategory4] == nil)
        #expect(parameters[.itemCategory5] == nil)
    }
    
    func testAnalyticsParameters_withSomeValues() {
        var item = AnalyticsItem(id: "123", name: "TestItem")
        item.affiliation = "TestAffiliation"
        item.coupon = "TestCoupon"
        item.discount = 10.0
        item.index = 1
        item.brand = "TestBrand"
        item.listId = "TestListId"
        item.listName = "TestListName"
        item.variant = "TestVariant"
        item.locationId = "TestLocationId"
        item.price = 99.99
        item.quantity = 2
        item.categories = ["Cat1", "Cat2", "Cat3", "Cat4", "Cat5", "Cat6"]
        
        let parameters = item.analyticsParameters
        #expect(parameters[.affiliation] as? String, "TestAffiliation")
        #expect(parameters[.coupon] as? String == "TestCoupon")
        #expect(parameters[.discount] as? Double == 10.0)
        #expect(parameters[.index] as? Int == 1)
        #expect(parameters[.itemId] as? String == "123")
        #expect(parameters[.itemName] as? String == "TestItem")
        #expect(parameters[.itemBrand] as? String == "TestBrand")
        #expect(parameters[.itemListId] as? String == "TestListId")
        #expect(parameters[.itemListName] as? String == "TestListName")
        #expect(parameters[.itemVariant] as? String == "TestVariant")
        #expect(parameters[.locationId] as? String == "TestLocationId")
        #expect(parameters[.price] as? Double == 99.99)
        #expect(parameters[.quantity] as? Int == 2)
        #expect(parameters[.itemCategory] as? String == "Cat1")
        #expect(parameters[.itemCategory2] as? String == "Cat2")
        #expect(parameters[.itemCategory3] as? String == "Cat3")
        #expect(parameters[.itemCategory4] as? String == "Cat4")
        #expect(parameters[.itemCategory5] as? String == "Cat5")
    }
    
    func testAnalyticsParameters_withExceedingCategories() {
        var item = AnalyticsItem(id: "123", name: "TestItem")
        item.categories = ["Cat1", "Cat2", "Cat3", "Cat4", "Cat5", "Cat6"]
        let parameters = item.analyticsParameters
        #expect(parameters[.itemCategory] as? String == "Cat1")
        #expect(parameters[.itemCategory2] as? String == "Cat2")
        #expect(parameters[.itemCategory3] as? String == "Cat3")
        #expect(parameters[.itemCategory4] as? String == "Cat4")
        #expect(parameters[.itemCategory5] as? String == "Cat5")
    }
    
    func testAnalyticsParameters_withPartialCategories() {
        var item = AnalyticsItem(id: "123", name: "TestItem")
        item.categories = ["Cat1", "Cat2"]
        let parameters = item.analyticsParameters
        #expect(parameters[.itemCategory] as? String == "Cat1")
        #expect(parameters[.itemCategory2] as? String == "Cat2")
        #expect(parameters[.itemCategory3] == nil)
        #expect(parameters[.itemCategory4] == nil)
        #expect(parameters[.itemCategory5] == nil)
    }
}
