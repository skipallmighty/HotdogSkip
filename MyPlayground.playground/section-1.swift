// Playground - noun: a place where people can play

import SpriteKit

for i in 1...5 {
    var toolTipLabel = SKLabelNode(fontNamed: "Courier")
    if i == 1 {
        toolTipLabel.position.y = toolTipLabel.position.y + 20
    }
    //            toolTipLabel.name = "tooltip\(i)"
    //            toolTipLabel.fontSize = 9
    //            toolTipLabel.fontColor = UIColor.blackColor()
    //            self.toolTips.append(toolTipLabel.name)
    //            self.toolTip.addChild(toolTipLabel)
}
