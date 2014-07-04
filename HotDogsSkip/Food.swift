//
//  Food.swift
//  HotDogsSkip
//
//  Created by Skip Wilson on 7/2/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import SpriteKit

enum FoodType:Int, Printable {
    
    case Bun = 0, Hotdog, Ketchup, Lettuce, Mustard
    
    var description:String {
    return Food.getFoods()[toRaw()]
    }
    
    var many:String {
    return getSprite(less: false)
    }
    
    var few:String {
    return getSprite(less: true)
    }
    
    
    func getSprite(#less:Bool) -> String {
        var moreOrLess = "many"
        if less {
            moreOrLess = "few"
        }
        return "\(Food.getFoods()[toRaw()])_\(moreOrLess)"
    }
    
}

enum FoodState:Int {
    case Many, Few, None
}

class Food:Printable {
    
    var foodType:FoodType
    var foodState:FoodState
    var sprite:SKSpriteNode
    var description:String {
    return "Food Class"
    }
    
    class func getFoodSpriteNames(foodName:String) -> String[] {
        if foodName == "bun" {
            return ["bun1", "bun2"]
        } else {
            return [foodName]
        }
    }
    
    class func getFoods() -> String[] {
        return ["bun","hotdog","ketchup","lettuce","mustard"]
    }
    
    class func getFoodTypes() -> FoodType[] {
        return [.Bun, .Hotdog, .Ketchup, .Lettuce, .Mustard]
    }
    
    init(foodType:FoodType, sprite:SKSpriteNode, foodState:FoodState = .Many) {
        self.foodType = foodType
        self.sprite = sprite
        self.foodState = foodState
    }
    
}
