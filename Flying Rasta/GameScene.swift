//
//  GameScene.swift
//  FlyinRasta
//
//  Created by Sepehr on 6/26/16.
//  Copyright (c) 2016 SkyBoss. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation

class GameScene: SKScene,SKPhysicsContactDelegate {
    
    let myDefaults = NSUserDefaults.standardUserDefaults()
    let scoreKey = "scoreKey"
    
    let guideNode = SKNode()
    var rastaman:Sprite!
    var line:SKShapeNode!
    var ground:SKNode!
    var playNode = SKNode()
    var treeNode = SKNode()
    var cloudNode = SKNode()
    var levelNode:SKNode!
    // Counters
    var treeCounter = 0
    var coconutCounter = 0
    var level = 0
    var rastaMuteC = 0
    var helperBarC = 0

    
    var spawnCloud:SKAction!
    var delayCloud:SKAction!
    var spawnThenDelayCloud:SKAction!
    var spawnThenDelayForeverCloud:SKAction!
    
    var sCloud = false
    var rotate = false
    var score = NSInteger()
    let scoreText = SKLabelNode(fontNamed: "AvenirNext-Bold")
    let hScoreText = SKLabelNode(fontNamed: "AvenirNext-Bold")
    var maxXFrame:CGFloat!
    var maxYFrame:CGFloat!
    var midPoint:CGPoint!
    /*
     * BUTTONS
     */
    let play_button = UIButton(type: UIButtonType.System)
    let re_play_button = UIButton(type: UIButtonType.System)
    let settings_button = UIButton(type: UIButtonType.System)
    let mute_rastaman_button = UIButton(type: UIButtonType.System)
    let helper_bar_button = UIButton(type: UIButtonType.System)
    let back_buttonS = UIButton(type: UIButtonType.System)
    let main_menu_button = UIButton(type: .System)
    var mute_button_str = "Mute Rastaman"
    //
    var g1:Sprite!
    let rastaCategory: UInt32 = 0x1 << 1
    let groundCategory: UInt32 = 0x1 << 2
    let treeCategory: UInt32 = 0x1 << 3
    let coconutCategory: UInt32 = 0x1 << 4
    let cloudCategory: UInt32 = 0x1 << 5
    let ecloudCategory: UInt32 = 0x1 << 6
    
    var tapMovement = 30
    var tapDuration = 0.5
    
    // Booleans
    var toPlay = false
    var helperBar = true
    var rastaSound = true
    
    var backgroundMusic:AVAudioPlayer!
    let bgMusicPath = NSBundle.mainBundle().pathForResource("psytrance-djembe-loops-05", ofType: "wav")
    var jump_sound:AVAudioPlayer!
    let jump_path = NSBundle.mainBundle().pathForResource("jump_up", ofType: "wav")
    
    var hit_sound:AVAudioPlayer!
    let hit_path = NSBundle.mainBundle().pathForResource("hit_hurt", ofType: "wav")
    
    var picked_sound:AVAudioPlayer!
    let picked_path = NSBundle.mainBundle().pathForResource("pickup_coconut", ofType: "wav")
    
    let box = SKShapeNode(rectOfSize: CGSize(width: 250, height: 200))
    let label = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    let highest = SKLabelNode(fontNamed: "MarkerFelt-Wide")
    
    override func didMoveToView(view: SKView) {
        
        //myDefaults.setInteger(0, forKey: scoreKey)
        re_play_button.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.77 ,(CGRectGetMidY(view.frame) - 50), 100, 30)
        re_play_button.backgroundColor = UIColor.whiteColor()
        re_play_button.layer.cornerRadius = 5
        re_play_button.layer.borderWidth = 1
        re_play_button.setTitle("Re-Play", forState: .Normal)
        re_play_button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        re_play_button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        re_play_button.addTarget(self, action: #selector(GameScene.reset), forControlEvents: .TouchUpInside)
        self.view!.addSubview(re_play_button)
        re_play_button.hidden = true
        
        main_menu_button.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.77 ,(CGRectGetMidY(view.frame)), 100, 30)
        main_menu_button.backgroundColor = UIColor.whiteColor()
        main_menu_button.layer.cornerRadius = 5
        main_menu_button.layer.borderWidth = 1
        main_menu_button.setTitle("Main Menu", forState: .Normal)
        main_menu_button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        main_menu_button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        main_menu_button.addTarget(self, action: #selector(GameScene.mainMenu), forControlEvents: .TouchUpInside)
        self.view!.addSubview(main_menu_button)
        main_menu_button.hidden = true
        
        play_button.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.77 ,CGRectGetMidY(view.frame), 100, 30)
        play_button.backgroundColor = UIColor.whiteColor()
        play_button.layer.cornerRadius = 5
        play_button.layer.borderWidth = 1
        play_button.setTitle("Play", forState: .Normal)
        play_button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        play_button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        play_button.addTarget(self, action: #selector(GameScene.startScene), forControlEvents: .TouchUpInside)
        self.view!.addSubview(play_button)
        play_button.hidden = false
        
        settings_button.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.77 ,(CGRectGetMidY(view.frame) + 50), 100, 30)
        settings_button.backgroundColor = UIColor.whiteColor()
        settings_button.layer.cornerRadius = 5
        settings_button.layer.borderWidth = 1
        settings_button.setTitle("Settings", forState: .Normal)
        settings_button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        settings_button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        settings_button.addTarget(self, action: #selector(GameScene.settingsMenu), forControlEvents: .TouchUpInside)
        self.view!.addSubview(settings_button)
        settings_button.hidden = false
        
        
        mute_rastaman_button.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.64 ,(CGRectGetMidY(view.frame) - 100), 150, 30)
        mute_rastaman_button.backgroundColor = UIColor.whiteColor()
        mute_rastaman_button.layer.cornerRadius = 5
        mute_rastaman_button.layer.borderWidth = 1
        mute_rastaman_button.setTitle(mute_button_str, forState: .Normal)
        mute_rastaman_button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        mute_rastaman_button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        mute_rastaman_button.addTarget(self, action: #selector(GameScene.muteRasta), forControlEvents: .TouchUpInside)
        self.view!.addSubview(mute_rastaman_button)
        mute_rastaman_button.hidden = true
        
        helper_bar_button.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.77 ,(CGRectGetMidY(view.frame) - 50), 100, 30)
        helper_bar_button.backgroundColor = UIColor.whiteColor()
        helper_bar_button.layer.cornerRadius = 5
        helper_bar_button.layer.borderWidth = 1
        helper_bar_button.setTitle("Helper bar line", forState: .Normal)
        helper_bar_button.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        helper_bar_button.setTitleColor(UIColor.brownColor(), forState: .Normal)
        helper_bar_button.addTarget(self, action: #selector(GameScene.helperBar_Func), forControlEvents: .TouchUpInside)
        self.view!.addSubview(helper_bar_button)
        helper_bar_button.hidden = true
        
        
        back_buttonS.frame = CGRectMake(CGRectGetMidX(view.frame) * 0.77 ,(CGRectGetMidY(view.frame) ), 100, 30)
        back_buttonS.backgroundColor = UIColor.whiteColor()
        back_buttonS.layer.cornerRadius = 5
        back_buttonS.layer.borderWidth = 1
        back_buttonS.setTitle("Back", forState: .Normal)
        back_buttonS.titleLabel?.font = UIFont(name: "MarkerFelt-Wide", size: 15)
        back_buttonS.setTitleColor(UIColor.brownColor(), forState: .Normal)
        back_buttonS.addTarget(self, action: #selector(GameScene.back_to_settings), forControlEvents: .TouchUpInside)
        self.view!.addSubview(back_buttonS)
        back_buttonS.hidden = true
        
        makeSky()
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        
        self.addChild(playNode)
        playNode.addChild(cloudNode)
        maxXFrame = CGRectGetMaxX(self.frame)
        maxYFrame = CGRectGetMaxY(self.frame)
        midPoint = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        
        
        label.text = "Game Over"
        label.fontSize = 40
        label.fontColor = SKColor.redColor()
        label.position = CGPoint(x:CGRectGetMidX(box.frame) , y: CGRectGetMaxY(box.frame) - 50)
        box.addChild(label)
        
        highest.text = "Highest Score"
        highest.fontSize = 20
        highest.fontColor = SKColor.whiteColor()
        highest.position = CGPoint(x:CGRectGetMinX(box.frame) + 67, y: CGRectGetMidY(box.frame))
        box.addChild(highest)
        
        hScoreText.fontSize = 20
        hScoreText.position = CGPoint(x: highest.position.x + 150, y: highest.position.y)
        box.addChild(hScoreText)
        
        box.position = CGPoint(x: midPoint.x + 4, y: midPoint.y + 65)
        box.zPosition = 1
        box.fillColor = SKColor.darkGrayColor()
        playNode.addChild(box)
        box.hidden = true
        
        let jump_url = NSURL(fileURLWithPath: jump_path!)
        let hit_url = NSURL(fileURLWithPath: hit_path!)
        let picked_url = NSURL(fileURLWithPath: picked_path!)
        let bgUrl = NSURL(fileURLWithPath: bgMusicPath!)
        
        do{
            backgroundMusic = try AVAudioPlayer(contentsOfURL: bgUrl)
            jump_sound = try AVAudioPlayer(contentsOfURL: jump_url)
            hit_sound = try AVAudioPlayer(contentsOfURL: hit_url)
            picked_sound = try AVAudioPlayer(contentsOfURL: picked_url)
            
        }
        catch{
            print("sound no bueno")
        }
        
        jump_sound.prepareToPlay()
        jump_sound.volume = 0.1
        hit_sound.prepareToPlay()
        picked_sound.prepareToPlay()
        picked_sound.volume = 0.3
        
        backgroundMusic.numberOfLoops = -1
        backgroundMusic.play()
        
        print("midpoint x: \(midPoint.x)")
        print("midpoint y: \(midPoint.y)")
        print("max X frame: \(maxXFrame)")
        print("max Y frame: \(maxYFrame)")
        
        previewScene()
        playScene()
        
    }
    
    func mainMenu()
    {
        box.hidden = true
        rastaman.sprite.constraints?.first?.enabled = true
        rastaman.sprite.constraints?.last?.enabled = true
        rastaman.sprite.physicsBody?.dynamic = true
        re_play_button.hidden = true
        main_menu_button.hidden = true
        treeNode.removeAllChildren()
        cloudNode.removeAllChildren()
        cloudNode.removeAllActions()
        rastaman.sprite.position = rastaman.originalPosition
        if(rotate)
        {
            rastaman.sprite.runAction(SKAction.rotateByAngle(-360, duration: 0))
        }
        tapMovement = 30
        tapDuration = 0.5 - 0.08
        coconutCounter = 0
        treeCounter = 0
        level = 3
        score = 0
        scoreText.text = String(score)
        rotate = false
        toPlay = false
        line.hidden = helperBar
        backgroundMusic.play()
        play_button.hidden = false
        settings_button.hidden = false
        
    }
    func back_to_settings()
    {
        play_button.hidden = false
        settings_button.hidden = false
        mute_rastaman_button.hidden = true
        helper_bar_button.hidden = true
        back_buttonS.hidden = true
        
    }
    func muteRasta()
    {
        if (rastaMuteC == 0) {
            rastaSound = false
            rastaMuteC = 1
            mute_button_str = "Un-Mute Rastaman"
            mute_rastaman_button.setTitle(mute_button_str, forState: .Normal)
            print("muted")
        }
        else if (rastaMuteC == 1)
        {
            rastaSound = true
            rastaMuteC = 0
            print("not muted")
            mute_button_str = "Mute Rastaman"
            mute_rastaman_button.setTitle(mute_button_str, forState: .Normal)
            jump_sound.play()
        }
    }
    func helperBar_Func()
    {
        if (helperBarC == 0) {
            helperBar = false
            line.hidden = false
            helperBarC = 1
            print("show")
        }
        else if (helperBarC == 1)
        {
            helperBar = true
            line.hidden = true
            helperBarC = 0
            print("hidden")
        }
    }
    func settingsMenu()
    {
        play_button.hidden = true
        settings_button.hidden = true
        mute_rastaman_button.hidden = false
        helper_bar_button.hidden = false
        back_buttonS.hidden = false
    }
    func playScene()
    {
        // score label
        scoreText.fontSize = 42
        scoreText.fontColor = SKColor.blackColor()
        scoreText.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) * 0.88)
        scoreText.text = String(score)
        playNode.addChild(scoreText)
        scoreText.name = "scoreText"
        scoreText.hidden = true
        
        // random cloud shoot
        let action = SKAction.moveByX(-maxXFrame, y: 0, duration: NSTimeInterval(5))
        let cloudDelay = SKAction.waitForDuration(1)
        let sequence = SKAction.sequence([action,SKAction.removeFromParent(),cloudDelay])
        
        
        spawnCloud = SKAction.runBlock({() in self.cloud(sequence)})
        delayCloud = SKAction.waitForDuration(NSTimeInterval(1.5))
        spawnThenDelayCloud = SKAction.sequence([spawnCloud, delayCloud])
        spawnThenDelayForeverCloud = SKAction.repeatActionForever(spawnThenDelayCloud)
        
        slevel()
        playNode.paused = true
        
    }
    func startScene()
    {
        scoreText.hidden = false
        guideNode.hidden = true
        play_button.hidden = true
        toPlay = true
        settings_button.hidden = true
        
        level = 3
        tapDuration -= 0.08
        playNode.speed = 1.4
        self.paused = false
        
    }
    
    func GameOver()
    {
        if(myDefaults.integerForKey(scoreKey) < score)
        {
            myDefaults.setInteger(score, forKey: scoreKey)
        }
        hScoreText.text = String(myDefaults.integerForKey(scoreKey))
        box.hidden = false
        re_play_button.hidden = false
        line.hidden = true
        main_menu_button.hidden = false
        //playNode.paused = true
        self.paused = true
        
    }
    func reset()
    {
        box.hidden = true
        rastaman.sprite.constraints?.first?.enabled = true
        rastaman.sprite.constraints?.last?.enabled = true
        rastaman.sprite.physicsBody?.dynamic = true
        re_play_button.hidden = true
        treeNode.removeAllChildren()
        cloudNode.removeAllChildren()
        cloudNode.removeAllActions()
        rastaman.sprite.position = rastaman.originalPosition
        //playNode.paused = false
        self.paused = false
        playNode.speed = 1.4
        if(rotate)
        {
            rastaman.sprite.runAction(SKAction.rotateByAngle(-360, duration: 0))
        }
        tapMovement = 30
        tapDuration = 0.5 - 0.08
        coconutCounter = 0
        treeCounter = 0
        level = 3
        score = 0
        scoreText.text = String(score)
        rotate = false
        toPlay = true
        line.hidden = helperBar
        backgroundMusic.play()
        main_menu_button.hidden = true
    }
    func topLayerCloud(action:SKAction)
    {
        let cloud0 = Sprite(name: "Cloud", size: CGSize(width: 40,height: 40), position: CGPoint(x: CGRectGetMaxX(self.frame) * 0.8, y: CGRectGetMaxY(self.frame) * 0.97), body:cloudCategory)
        cloud0.sprite.physicsBody = SKPhysicsBody(circleOfRadius: cloud0.sprite.size.width,center: CGPoint(x: cloud0.sprite.size.width/2, y: cloud0.sprite.size.height/2))
        cloud0.sprite.physicsBody?.dynamic = false
        cloud0.sprite.physicsBody?.categoryBitMask = cloudCategory
        cloud0.sprite.runAction(action)
        playNode.addChild(cloud0)
        
    }
    func cloud(action:SKAction)
    {
        //Cloud
        var ran = Int(arc4random_uniform(4))
        
        switch ran
        {
        case 0:
            ran = Int(midPoint.y)
        case 1:
            ran = Int(midPoint.y) + 80
        case 2:
            ran = Int(midPoint.y) + (80) * 2
        case 3:
            ran = Int(midPoint.y) + (80) * 3
        default:
            print("defulat case number: \(ran)")
        }
        let cloud = Sprite(name: "Cloud", size: CGSize(width: 40,height: 40), position: CGPoint(x: CGRectGetMaxX(self.frame),y:CGFloat(ran)), body:cloudCategory)
        
        cloud.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 40, height: 40))
        cloud.sprite.physicsBody?.categoryBitMask = cloudCategory
        cloud.sprite.physicsBody?.dynamic = false
        
        
        let eastCircle = SKNode()
        
        eastCircle.position = CGPoint(x: cloud.sprite.position.x - 14, y: cloud.sprite.position.y - 2)
        eastCircle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 8, height: 8))
        eastCircle.physicsBody?.dynamic = false
        eastCircle.physicsBody?.categoryBitMask = ecloudCategory
        
        cloud.sprite.runAction(action)
        eastCircle.runAction(action)
        cloud.sprite.zPosition = -1
        cloudNode.addChild(eastCircle)
        cloudNode.addChild(cloud)
        
    }
    func spawnTrees(action:SKAction,position:CGPoint) {
        
        var tree:Sprite!
        
        if(level == 1)
        {
            switch treeCounter
            {
            case 0:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 4), position: position,body: treeCategory)
            case 1:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 6), position: CGPoint(x: position.x, y:position.y + 40) ,body: treeCategory)
            default:
                print("incorrect entry")
                
            }
            treeCounter += 1
            coconutCounter += 1
            tree.sprite.zPosition = -1
            tree.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: tree.sprite.size.width * 0.1 , height: tree.sprite.size.height - 10))
            tree.sprite.physicsBody?.dynamic = false
            tree.sprite.physicsBody?.categoryBitMask = treeCategory
            tree.runAction(action)
            treeNode.addChild(tree)
            if(treeCounter == 2)
            {
                treeCounter = 0
            }
        }// end if level 1
            
        else if(level == 2)
        {
            print("level 2 \(treeCounter)")
            switch treeCounter
            {
            case 0:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 4), position: position,body: treeCategory)
            case 1:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 8), position: CGPoint(x: position.x, y:position.y + 80),body: treeCategory)
            default:
                print("inccorect entry")
                
            }
            treeCounter += 1
            coconutCounter += 1
            tree.sprite.zPosition = -1
            tree.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: tree.sprite.size.width * 0.1 , height: tree.sprite.size.height - 10))
            tree.sprite.physicsBody?.dynamic = false
            tree.sprite.physicsBody?.categoryBitMask = treeCategory
            tree.runAction(action)
            treeNode.addChild(tree)
            if(treeCounter == 2)
            {
                treeCounter = 0
            }
        }// end if level 2
        else if(level == 3)
        {
            switch treeCounter
            {
            case 0:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 4), position: position,body: treeCategory)
            case 1:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 8), position: CGPoint(x: position.x, y:position.y + 80),body: treeCategory)
            case 2:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 4), position: position,body: treeCategory)
                
            case 3:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 6), position: CGPoint(x: position.x, y:position.y + 40) ,body: treeCategory)
            case 4:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 8), position: CGPoint(x: position.x, y:position.y + 80),body: treeCategory)
            case 5:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 6), position: CGPoint(x: position.x, y:position.y + 40) ,body: treeCategory)
            default:
                print("inccorect entry")
            }
            treeCounter += 1
            coconutCounter += 1
            tree.sprite.zPosition = -1
            tree.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: tree.sprite.size.width * 0.1 , height: tree.sprite.size.height - 10))
            tree.sprite.physicsBody?.dynamic = false
            tree.sprite.physicsBody?.categoryBitMask = treeCategory
            tree.runAction(action)
            treeNode.addChild(tree)
            if(treeCounter == 6)
            {
                treeCounter = 0
            }
            if(sCloud)
            {
                cloudNode.runAction(spawnThenDelayForeverCloud)
                sCloud = false // needs to only be called once
            }
        }// end level 3
        else if(level == 5)
        {
            switch randomInRange(1...3)
            {
            case 1:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 4), position: position,body: treeCategory)
            case 2:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 6), position: CGPoint(x: position.x, y:position.y + 40) ,body: treeCategory)
            case 3:
                tree = Sprite(name: "Palm_Tree", size:CGSize(width: self.rastaman.sprite.size.height * 2, height: self.rastaman.sprite.size.width * 8), position: CGPoint(x: position.x, y:position.y + 80),body: treeCategory)
            default:
                print("inccorect entry")
            }
            coconutCounter += 1
            tree.sprite.zPosition = -1
            tree.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: tree.sprite.size.width * 0.1 , height: tree.sprite.size.height - 10))
            tree.sprite.physicsBody?.dynamic = false
            tree.sprite.physicsBody?.categoryBitMask = treeCategory
            tree.runAction(action)
            treeNode.addChild(tree)
        }
        if(coconutCounter == 3)
        {
            coconutCounter = 0
            let coconut = Sprite(name: "Coconut", size: CGSize(width: 25,height: 25 ), position: CGPoint(x: tree.sprite.position.x, y: CGRectGetMaxY(tree.sprite.frame) + 30), body: coconutCategory)
            
            coconut.sprite.physicsBody = SKPhysicsBody(circleOfRadius: 20)
            coconut.sprite.physicsBody?.dynamic = false
            coconut.sprite.physicsBody?.categoryBitMask = coconutCategory
            coconut.sprite.runAction(action)
            treeNode.addChild(coconut)
        }
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if(toPlay)
        {
            for touch : AnyObject in touches{
                
                let location = touch.locationInNode(self)
                if(location.y > self.rastaman.sprite.position.y)
                {
                    rastaman.sprite.runAction(SKAction.moveByX(0, y: CGFloat(tapMovement), duration: tapDuration))
                    if(rastaSound)
                    {
                        jump_sound.play()
                    }
                }
                else if(location.y < self.rastaman.sprite.position.y)
                {
                    rastaman.sprite.runAction(SKAction.moveByX(0, y: CGFloat(-tapMovement), duration: tapDuration))
                    if(rastaSound)
                    {
                        jump_sound.play()
                    }
                }
            }
        }
    }
    func didBeginContact(contact: SKPhysicsContact) {
        let body1 = contact.bodyA
        let body2 = contact.bodyB
        
        
        if(body1.categoryBitMask == rastaCategory)
        {
            if(body2.categoryBitMask == coconutCategory)
            {
                picked_sound.play()
                body2.node?.removeFromParent()
                score += 1
                scoreText.text = String(score)

                if(score == 4)
                {
                    sCloud = true // level 4
                    print("level 4")
                }
                else if(score == 10)
                {
                    level = 5
                }
                
                if(playNode.speed + 0.05 <= 4.0)
                {
                    playNode.speed += 0.05
                }
                print("playnode speed: \(playNode.speed)")
                if(tapDuration - 0.05 > 0)
                {
                    tapDuration -= 0.05
                    print("tab duration: \(tapDuration)")
                }
                else if(tapMovement + 5 <= 60)
                {
                    tapMovement += 5
                    print("tap movement: \(tapMovement)")
                }
            }
            
            if(body2.categoryBitMask == treeCategory)
            {
                hit_sound.play()
                rastaman.sprite.constraints?.first?.enabled = false
                rastaman.sprite.constraints?.last?.enabled = false
                rastaman.sprite.physicsBody?.dynamic = false
                rastaman.sprite.runAction(SKAction.sequence([SKAction.rotateByAngle(360, duration: NSTimeInterval(0.1)),SKAction.moveByX(-100, y: rastaman.sprite.position.y, duration: 1)]))
                playNode.speed = 0
                rotate = true
                backgroundMusic.stop()
                toPlay = false
                GameOver()
            }
            
            if(body2.categoryBitMask == groundCategory)
            {
                hit_sound.play()
                rastaman.sprite.constraints?.first?.enabled = false
                rastaman.sprite.physicsBody?.dynamic = false
                rastaman.sprite.runAction(SKAction.sequence([SKAction.rotateByAngle(360, duration: NSTimeInterval(0.1)),SKAction.moveByX(-100, y: rastaman.sprite.position.y, duration: 1)]))
                playNode.speed = 0
                rotate = true
                backgroundMusic.stop()
                toPlay = false
                GameOver()
            }
            //            if(body2.categoryBitMask == cloudCategory)
            //            {
            //                print("body1 contact: \(contact.contactPoint)")
            //                print("hits cloud")
            //            }
            if(body2.categoryBitMask == ecloudCategory)
            {
                hit_sound.play()
                rastaman.sprite.constraints?.first?.enabled = false
                rastaman.sprite.physicsBody?.dynamic = false
                rastaman.sprite.runAction(SKAction.moveByX( -(maxXFrame/4), y: 0, duration: 1))
                playNode.speed = 0
                backgroundMusic.stop()
                toPlay = false
                GameOver()
            }
        }
        
    }
    func randomInRange(range: Range<Int>) -> Int{
        let count = UInt32(range.endIndex - range.startIndex)
        return  Int(arc4random_uniform(count)) + range.startIndex
    }
    
    func makeSky()
    {
        var index = 0
        var frameHeight:CGFloat = 0
        var greenValue:CGFloat = 0.8
        var blueValue:CGFloat = 1.6
        while(index < 5)
        {
            let background = SKShapeNode(rectOfSize: CGSize(width: self.frame.size.width * 0.5, height: self.frame.size.height * 0.25))
            let backGroundColor:SKColor = SKColor(red: 0, green: greenValue, blue: blueValue, alpha: 1)
            
            
            background.fillColor = backGroundColor
            background.strokeColor = SKColor(red: 0, green: greenValue, blue: blueValue, alpha: 0)
            greenValue -= 0.1
            blueValue -= 0.2
            background.zPosition = -2
            background.position = CGPoint(x: frame.size.width/2, y: self.frame.size.height * frameHeight)
            frameHeight += 0.25
            
            self.addChild(background)
            index += 1
        }
    }
    func slevel()
    {
        let treePosition = CGPoint(x:self.frame.size.width, y: g1.sprite.size.height + 80)
        let moveTree = SKAction.moveByX(-(maxXFrame), y: 0, duration: NSTimeInterval(maxYFrame - (maxYFrame * 0.99)))
        let removeTree = SKAction.removeFromParent()
        let moveTreeAndRemove = SKAction.sequence([moveTree,removeTree])
        
        
        let spawn = SKAction.runBlock({() in self.spawnTrees(moveTreeAndRemove,position:treePosition)})
        let delay = SKAction.waitForDuration(NSTimeInterval(1.5))
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        let spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        playNode.runAction(spawnThenDelayForever)
        playNode.addChild(treeNode)
    }
    
    func previewScene()
    {
        let upArrow = SKSpriteNode(imageNamed: "Arrow_up")
        upArrow.size = CGSize(width: 50, height: 50)
        let downArrow = SKSpriteNode(imageNamed: "Arrow_down")
        downArrow.size = CGSize(width: 50, height: 50)
        
        upArrow.anchorPoint = CGPoint(x: 0.5, y: 0)
        upArrow.position = CGPoint(x: midPoint.x + 130, y: midPoint.y + 60)
        
        downArrow.anchorPoint = CGPoint(x: 0.5, y: 1)
        downArrow.position = CGPoint(x: midPoint.x + 130, y: midPoint.y + 40)
        
        guideNode.addChild(upArrow)
        guideNode.addChild(downArrow)
        
        let up_text = SKLabelNode(text: "Tap to go up")
        let down_text = SKLabelNode(text: "Tap to go down")
        
        up_text.position = CGPoint(x: upArrow.position.x - 30, y: upArrow.position.y + 60)
        down_text.position = CGPoint(x: upArrow.position.x - 30, y: upArrow.position.y - 90)
        
        guideNode.addChild(up_text)
        guideNode.addChild(down_text)
        
        playNode.addChild(guideNode)

        
        //Cloud top layer
        let moveCloud = SKAction.moveByX(-maxXFrame, y:0.0, duration:NSTimeInterval(5))
        let removeClouds = SKAction.removeFromParent()
        let moveCloudAndRemove = SKAction.sequence([moveCloud, removeClouds])
        /*spawn the clouds top layer*/
        spawnCloud = SKAction.runBlock({() in self.topLayerCloud(moveCloudAndRemove)})
        delayCloud = SKAction.waitForDuration(NSTimeInterval(0.5))
        spawnThenDelayCloud = SKAction.sequence([spawnCloud, delayCloud])
        spawnThenDelayForeverCloud = SKAction.repeatActionForever(spawnThenDelayCloud)
        playNode.runAction(spawnThenDelayForeverCloud)
        
        //Rastaman
        let movePositive = SKAction.moveBy(CGVector(dx: 0, dy: 5), duration: 0.5)
        let redo = SKAction.sequence([movePositive,movePositive.reversedAction(),movePositive.reversedAction(),movePositive])
        self.rastaman = Sprite(name: "Rastaman", size: CGSize(width: 50,height: 50), position: CGPoint(x: midPoint.x * 0.65,y: midPoint.y), action: SKAction.repeatActionForever(redo), body: rastaCategory)
        self.rastaman.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: self.rastaman.sprite.size.width - 5, height: self.rastaman.sprite.size.height - 20))
        self.rastaman.sprite.physicsBody?.dynamic=true
        self.rastaman.sprite.physicsBody?.affectedByGravity = false
        self.rastaman.sprite.physicsBody?.allowsRotation = false
        self.rastaman.sprite.physicsBody?.restitution = 0
        self.rastaman.sprite.physicsBody?.linearDamping = 0
        self.rastaman.sprite.physicsBody?.friction = 0
        self.rastaman.sprite.physicsBody?.categoryBitMask = rastaCategory
        self.rastaman.sprite.physicsBody?.collisionBitMask = ecloudCategory | cloudCategory | groundCategory
        self.rastaman.sprite.physicsBody?.contactTestBitMask = groundCategory | treeCategory | coconutCategory | ecloudCategory | cloudCategory
        let cons:NSArray = [SKConstraint.positionX(SKRange.init(constantValue: self.rastaman.originalPosition.x)),SKConstraint.positionY(SKRange.init(upperLimit: CGFloat(CGRectGetMaxY(self.frame) * 0.95)))]
        self.rastaman.sprite.constraints = (cons as! [SKConstraint])
        self.addChild(rastaman)
        
        line = SKShapeNode(rectOfSize: CGSize(width: maxXFrame, height: 2))
        line.zPosition = -2
        line.fillColor = SKColor.blueColor()
        line.position = CGPoint(x: rastaman.sprite.size.width/2, y: rastaman.sprite.size.height/4 - 15)
        rastaman.sprite.addChild(line)
        line.hidden = true
        // Ground
        let g1Position = CGPoint(x: midPoint.x - (midPoint.x*0.5),y:midPoint.y*0.2)
        let g2Position = CGPoint(x: midPoint.x + (midPoint.x*0.5),y:midPoint.y*0.2)
        g1 = Sprite(name: "Ground", size: CGSize(width:(maxXFrame/2),height:maxYFrame*0.2) , position:g1Position , action: SKAction.repeatActionForever(SKAction.sequence([SKAction.moveByX( -(maxXFrame/2),y: 0, duration: NSTimeInterval((maxXFrame/2) - (maxXFrame/2)*0.99)),SKAction.moveTo(g1Position, duration: 0)])), body: groundCategory)
        g1.sprite.anchorPoint = CGPoint(x: 0, y: 0.5)
        g1.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: g1.sprite.size.width, height: g1.sprite.size.height))
        g1.sprite.physicsBody?.dynamic = false
        g1.sprite.physicsBody?.categoryBitMask = groundCategory
        
        let g2 = Sprite(name: "Ground", size: CGSize(width:(maxXFrame/2),height:maxYFrame*0.2) , position:g2Position , action: SKAction.repeatActionForever(SKAction.sequence([SKAction.moveByX( -(maxXFrame/2),y: 0, duration: NSTimeInterval((maxXFrame/2) - (maxXFrame/2)*0.99)),SKAction.moveTo(g2Position, duration: 0)])), body: groundCategory)
        g2.sprite.anchorPoint = CGPoint(x: 0, y: 0.5)
        
        g2.sprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: g2.sprite.size.width, height: g2.sprite.size.height))
        g2.sprite.physicsBody?.dynamic = false
        g2.sprite.physicsBody?.categoryBitMask = groundCategory
        
        ground = SKNode()
        ground.addChild(g1)
        ground.addChild(g2)
        //        ground.physicsBody = SKPhysicsBody(rectangleOfSize:CGSize(width: g1.sprite.size.width * 2, height: g1.sprite.size.height),center: CGPoint(x: g1.sprite.size.width/2, y: g1.sprite.size.height / 2))
        //        ground.physicsBody?.dynamic = false
        //        ground.physicsBody?.categoryBitMask = groundCategory
        self.addChild(ground)
    }
}

