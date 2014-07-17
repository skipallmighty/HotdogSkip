//
//  GameScene.swift
//  HotDogsSkip
//
//  Created by Skip Wilson on 7/2/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let background = SKSpriteNode(imageNamed: "background")
    let foodArea = SKSpriteNode(imageNamed: "foodarea")
    
    let scoreBoard = SKLabelNode(fontNamed: "Courier")
    
    var people  = [Person]()
    var foods = [Food]()
    
    var hotdog:Hotdog?
    
    var timer = NSTimer()
    
    var hotDogContainer = SKSpriteNode()
    var hotdogContainerOrigPosition = CGPoint()
    var hotdogDragging = false
    var unsatified = 0
    
    var score = 0.0
    
    override func didMoveToView(view: SKView) {
        anchorPoint = CGPoint(x: 0.5,y: 0.5)
        
        foodArea.position.y = CGFloat(CGRectGetMinY(self.frame)) + foodArea.size.height / 2
        scoreBoard.fontColor = UIColor.redColor()
        scoreBoard.fontSize = 30
        scoreBoard.text = "$0.00"
        scoreBoard.position = CGPointMake(CGRectGetMaxX(self.frame) - 50, CGRectGetMaxY(self.frame) - 50)
        
        addChild(background)
        addPeople()
        addChild(foodArea)
        addFood()
        startTimer()
        addHotDog()
        addChild(scoreBoard)
    }
    
    func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("updateTimer"), userInfo: nil, repeats: true)
    }
    
    func updateTimer() {
        for person in people {
            if !person.leaving {
                if person.setAnger(Int(NSDate.timeIntervalSinceReferenceDate() - person.lastAnger)) {
                    if ++unsatified > 4 {
                        println("You lose")
                    }
                }
            }
            if person.off && !person.comingIn {
                person.comeIn()
            }
        }
    }
    
    func addHotDog() {
        hotDogContainer.position = CGPointMake(CGRectGetMaxX(self.frame) - 40, CGRectGetMinY(self.frame) + 30)
        hotdogContainerOrigPosition = hotDogContainer.position
        hotDogContainer.name = "hotdogContainer"
        self.addChild(hotDogContainer)
        hotdog = Hotdog(sprite: hotDogContainer)
    }
    
    func addPeople() {
        for(index, person) in enumerate(Person.getPeopleTypes()) {
            let sprite = SKSpriteNode(imageNamed: person.drawing)
            sprite.name = "person_\(index)"
            sprite.position = CGPointMake(100 + CGRectGetMinX(self.frame) + sprite.size.width * CGFloat(index), 0)
            self.addChild(sprite)
            people.append(Person(personType: person, sprite: sprite))
        }
    }
    
    func addFood() {
        for(index,food) in enumerate(Food.getFoodTypes()) {
            let sprite = SKSpriteNode(imageNamed: food.many)
            sprite.name = "ingredient_\(Food.getFoods()[food.toRaw()])"
            sprite.anchorPoint = CGPoint(x: 0, y: 0.5)
            sprite.position = CGPointMake(
                (CGRectGetMinX(self.frame)) + sprite.size.width * CGFloat(index)
                , CGFloat(CGRectGetMinY(self.frame)) + sprite.size.height / 2)
            self.addChild(sprite)
            foods.append(Food(foodType: food, sprite: sprite))
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches{
            let location = touch.locationInNode(self)
            println(location)
            var sprite = self.nodeAtPoint(location)
            if let spriteName = sprite.name{
                if spriteName.hasPrefix("ingredient_") {
                    var splitStringBy_ = sprite.name.componentsSeparatedByString("_")
                    var foodName = splitStringBy_[1]
                    self.hotdog!.addFoodLayer(Food.getFoodTypes()[find(Food.getFoods(), foodName)!])
                }
                else {
                    if ((!spriteName.hasPrefix("person_"))&&(!spriteName.hasPrefix("tooltip"))) {
                        if sprite.parent.name == "hotdogContainer" {
                            hotdogDragging = true
                        }
                    }
                }
            }
            return
        }
    }

    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!) {
        if (hotdogDragging == true) {
            let touch:AnyObject! = touches.anyObject()
            let positionOnScene = touch.locationInNode(self)
            let previousPosition = touch.previousLocationInNode(self)
            let translation = CGPointMake(positionOnScene.x - previousPosition.x, positionOnScene.y - previousPosition.y)
            var position = hotDogContainer.position
            hotDogContainer.position = CGPointMake(position.x + translation.x, position.y + translation.y)
        }
    }
    
    func getPersonForSprite(personForSprite:SKSpriteNode) -> Person? {
        for person in people {
            if person.sprite == personForSprite {
                return person
            }
        }
        return nil
    }
    
    func clearOrder(person:Person) {
        person.currentOrder.createOrder()
        hotdog!.initStatus()
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        hotdogDragging = false
        
        let touch:AnyObject! = touches.anyObject()
        let positionInScene = touch.locationInNode(self)
        var goodOrder = true
        var isOrder = false
        var person:Person?
        
        for thing:AnyObject in self.nodesAtPoint(positionInScene) {
            if let sprite = thing as? SKSpriteNode {
                if sprite.name {
                    if sprite.name.hasPrefix("person_") {
                        person = getPersonForSprite(sprite)
                        for item in person!.currentOrder.items {
                            println(hotdog!.statuses[item.foodType])
                            print(item.quantity)
                            if hotdog!.statuses[item.foodType] == item.quantity {
                                isOrder = true
                            } else {
                                goodOrder = false
                                break
                            }
                        }
                    }
                }
            }
        }
        if goodOrder && isOrder && person {
            score += 2.25
            setMoney()
            clearOrder(person!)
            hotDogContainer.position = hotdogContainerOrigPosition
            person!.leave()
        } else {
            var moveBackAction = SKAction.moveTo(hotdogContainerOrigPosition, duration: 0.2)
            moveBackAction.timingMode = SKActionTimingMode.EaseIn
            hotDogContainer.runAction(moveBackAction)
        }
    }
    
    func setMoney() {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        scoreBoard.text = formatter.stringFromNumber(score)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
