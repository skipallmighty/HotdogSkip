//
//  Order.swift
//  HotDogsSkip
//
//  Created by Skip Wilson on 7/2/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import SpriteKit

class Order:Printable {
    
    var description:String {
    return "Order"
    }
    
    var items = OrderItem[]()
    
    func createOrder() {
        items = []
        var numberOfFoods = UInt32(Food.getFoods().count)
        var numberOfItems = Int(1 + arc4random_uniform(numberOfFoods - 1))
        var hotdogAndBunCount = Int(1 + arc4random_uniform(UInt32(5)))
        var i = 0
        for i in 0...numberOfItems {
            if Food.getFoodTypes()[i] == FoodType.Hotdog || Food.getFoodTypes()[i] == FoodType.Bun {
                items.append(OrderItem(foodType: Food.getFoodTypes()[i], quantity: hotdogAndBunCount))
            } else {
                items.append(OrderItem(foodType: Food.getFoodTypes()[i], quantity: Int(1 + arc4random_uniform(UInt32(5)))))
            }
        }
    }
    
}

class OrderItem:Printable{
    var description:String {
    return "OrderItem"
    }
    
    var foodType:FoodType
    var quantity:Int
    
    init(foodType:FoodType, quantity:Int) {
        self.foodType = foodType
        self.quantity = quantity
    }
}