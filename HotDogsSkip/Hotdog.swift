//
//  Hotdog.swift
//  HotDogsSkip
//
//  Created by Skip Wilson on 7/2/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import SpriteKit

class Hotdog {

    var sprite:SKSpriteNode;
    
    let hotdogAtlas = SKTextureAtlas(named: "hotdog")
 
    var foodSprites = String[]()
    
    var statuses:Dictionary<FoodType, Int> = [:]
    
    func addHotdog() {
        initHotdogParts(FoodType.Bun, order: [0,3])
        initHotdogParts(FoodType.Hotdog, order: [1])
        initHotdogParts(FoodType.Lettuce, order: [2])
        initHotdogParts(FoodType.Ketchup, order: [4])
        initHotdogParts(FoodType.Mustard, order: [5])
        createFoodSprites()
    }
    
    func addFoodLayer(foodType:FoodType) {
        var quantity = statuses[foodType]!
        println(quantity)
        statuses[foodType] = quantity + 1
        setFoodVisibility(foodType)
        print(quantity)
    }
    
    func setFoodVisibility(foodType:FoodType) {
        if statuses[foodType] > 0 {
            //show the layer if quantity is greater than 0
            for name in Food.getFoodSpriteNames(Food.getFoods()[foodType.toRaw()]) {
                self.sprite.childNodeWithName(name).hidden = false
            }
        } else {
            for name in Food.getFoodSpriteNames(Food.getFoods()[foodType.toRaw()]) {
                self.sprite.childNodeWithName(name).hidden = true
            }
        }
    }
    
    func initStatus() {
        for foodType in Food.getFoodTypes() {
            statuses[foodType] = 0
            setFoodVisibility(foodType)
        }
    }
    
    func initHotdogParts(foodType:FoodType, order:Int[]) {
        var foodPart = SKSpriteNode()
        for (index, name) in enumerate(Food.getFoodSpriteNames(Food.getFoods()[foodType.toRaw()])) {
            foodSprites[order[index]] = name
        }
    }
    
    func createFoodSprites() {
        var foodPart = SKSpriteNode()
        for foodName in foodSprites {
            foodPart = SKSpriteNode(texture: hotdogAtlas.textureNamed(foodName))
            foodPart.name = foodName
            foodPart.hidden = true
            sprite.addChild(foodPart)
            println(foodName)
        }
    }
    
    
    
    init(sprite:SKSpriteNode) {
        self.sprite = sprite
        foodSprites = String[](count:hotdogAtlas.textureNames.count, repeatedValue:"")
        addHotdog()
        initStatus()
    }
}
