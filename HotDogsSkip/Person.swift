//
//  Person.swift
//  HotDogsSkip
//
//  Created by Skip Wilson on 7/2/14.
//  Copyright (c) 2014 Skip Wilson. All rights reserved.
//

import SpriteKit

enum PersonType:Int, Printable {
    case Person1 = 0, Person2, Person3
    
    var description:String {
    return "PersonType"
    }
    
    var drawing:String {
    return "\(Person.getPeople()[toRaw()])"
    }
}

class Person:Printable {
    
    var personType:PersonType;
    var sprite:SKSpriteNode;
    var timeToAnger = NSTimeInterval()
    
    var leaving = false
    var comingIn = false
    
    var currentOrder:Order = Order()
    
    var angerAtlas = SKTextureAtlas(named: "anger")
    var angerAtlasFrames = SKTexture[]()
    var angerSprite = SKSpriteNode()
    var angerLevel = 0
    var lastAnger = 0.0
    var off = false
    let toolTip = SKSpriteNode(imageNamed: "tooltip")
    var toolTips = String[]()
    
    var origPosition:CGPoint
    
    var description:String {
    return "Person"
    }
    
    class func getPeople() -> String[] {
        return ["person1","person2","person3"]
    }
    
    class func getPeopleTypes() -> PersonType[] {
        return [.Person1, .Person2, .Person3]
    }
    
    func setAngerFrames() {
        for i in 0..<self.angerAtlas.textureNames.count {
            angerAtlasFrames.append(angerAtlas.textureNamed("anger_\(i)"))
        }
    }
    
    func setAnger(waitTime:Int) -> Bool {
        if leaving || comingIn {
            return false
        }
        
        if waitTime == timeToAnger {
            if angerLevel < 6 {
                angerLevel++
                self.angerSprite.texture = SKTexture(imageNamed: "anger_\(angerLevel)")
                resetLastAnger()
                return false
            } else {
                leaving = true
                leave()
                return true
            }
        }
        return false
    }
    
    func leave() {
        var leaveAction = SKAction.moveToX(CGFloat(1000), duration: 2)
        leaveAction.timingMode = SKActionTimingMode.EaseIn
        self.sprite.runAction(leaveAction) {
            self.off = true
            self.resetAngerFrames()
            self.setTextForToolTip()
        }
    }
    
    func comeIn() {
        leaving = false
        comingIn = true
        var comingInAction = SKAction.moveToX(origPosition.x, duration: 2)
        comingInAction.timingMode = SKActionTimingMode.EaseOut
        sprite.runAction(comingInAction) {
            self.off = false
            self.resetLastAnger()
            self.angerLevel = 0
            self.resetAngerFrames()
            self.comingIn = false
        }
    }
    
    func resetAngerFrames() {
        angerSprite.texture = SKTexture(imageNamed: "anger_0")
    }
    
    func resetLastAnger() {
        self.lastAnger = NSDate.timeIntervalSinceReferenceDate()
    }
    
    func initAngerFrames() {
        self.angerSprite = SKSpriteNode(texture: angerAtlasFrames[0])
    }
    
        func setTextForToolTip() {
        for toolTip in toolTips {
            var thisToolTip = self.toolTip.childNodeWithName(toolTip) as SKLabelNode
            thisToolTip.text = ""
        }
        
        for (index, item) in enumerate(self.currentOrder.items) {
            var currentToolTipLabel = self.toolTip.childNodeWithName(self.toolTips[index]) as SKLabelNode
            if (self.currentOrder.items[index].quantity>0) {
                currentToolTipLabel.text = "\(self.currentOrder.items[index].quantity) \(self.currentOrder.items[index].foodType.description)s"
            } else {
                currentToolTipLabel.text = "no \(self.currentOrder.items[index].foodType.description)s"
            }
            
        }
    }

    
    init(personType:PersonType, sprite:SKSpriteNode) {
        self.personType = personType
        self.sprite = sprite
        self.origPosition = sprite.position
        self.timeToAnger = NSTimeInterval(1 + arc4random_uniform(4))
        currentOrder.createOrder()
        self.toolTip.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.toolTip.position.y = CGRectGetMaxY(self.sprite.frame) + (self.toolTip.size.height / 2)
        self.sprite.addChild(self.toolTip)
        
        for i in 1...5 {
            var lastToolTipLabel = self.toolTip.childNodeWithName("tooltip\(i-1)") as? SKLabelNode
            var toolTipLabel = SKLabelNode(fontNamed: "Courier")
            if i == 1 {
                toolTipLabel.position.y = toolTipLabel.position.y + 20
            }else {
                //last tooltip
                toolTipLabel.position.y = lastToolTipLabel!.position.y - 10
            }
            toolTipLabel.name = "tooltip\(i)"
            toolTipLabel.fontSize = 9
            toolTipLabel.fontColor = UIColor.blackColor()
            self.toolTips.append(toolTipLabel.name)
            self.toolTip.addChild(toolTipLabel)
        }
        
        setTextForToolTip()
        
        resetLastAnger()
        setAngerFrames()
        initAngerFrames()
        self.angerSprite.position.x += 50
        self.sprite.addChild(self.angerSprite)
    }
    
}
