//
//  Sprite.swift
//  FlyinRasta
//
//  Created by Sepehr on 6/26/16.
//  Copyright © 2016 SkyBoss. All rights reserved.
//



import SpriteKit
class Sprite:SKNode,Sprite_Protocol{
    var texture:SKTexture
    var sprite:SKSpriteNode
    var sPosition:CGPoint
    var originalPosition:CGPoint
    var action:SKAction
    var body:UInt32
    var pause:Bool
    
    required init(name:String?,size:CGSize?,position:CGPoint?,action:SKAction?,body:UInt32?)
    {
        self.texture = SKTexture(imageNamed: name!)
        self.sprite = SKSpriteNode(texture: texture, size: size!)
        self.sprite.name = name!
        self.sPosition = position!
        self.originalPosition = self.sPosition
        self.action = action!
        self.body = body!
        self.pause = true
        super.init() // matters where you put it
        self.sprite.position = self.sPosition
        sprite.runAction(action!)
        self.addChild(sprite)
        
    }
    
    required init(name:String?,size:CGSize?,position:CGPoint?,body:UInt32?)
    {
        action = SKAction()
        self.texture = SKTexture(imageNamed: name!)
        self.sprite = SKSpriteNode(texture: texture, size: size!)
        self.sprite.name = name!
        self.sPosition = position!
        self.originalPosition = self.sPosition
        self.body = body!
        self.pause = true
        super.init() // matters where you put it
        self.sprite.position = self.sPosition
        self.addChild(sprite)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

