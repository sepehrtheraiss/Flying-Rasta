//
//  Sprite_Protocol.swift
//  FlyinRasta
//
//  Created by Sepehr on 6/26/16.
//  Copyright © 2016 SkyBoss. All rights reserved.
//

import SpriteKit

protocol Sprite_Protocol {
    var texture:SKTexture {get set}
    var sprite:SKSpriteNode {get}
    var sPosition:CGPoint {get set}
    var originalPosition:CGPoint {get set}
    var action:SKAction {get set}
    var body:UInt32 {get set}
    var pause:Bool {get set}
    
    init(name:String?,size:CGSize?,position:CGPoint?,action:SKAction?,body:UInt32?)
    init(name:String?,size:CGSize?,position:CGPoint?,body:UInt32?)
    
}
