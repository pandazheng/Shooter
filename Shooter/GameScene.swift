//
//  GameScene.swift
//  Shooter
//
//  Created by Jared Davidson on 7/20/15.
//  Copyright (c) 2015 Archetapp. All rights reserved.
//

import SpriteKit


struct PhysicsCatagory {
    static let Enemy :UInt32 = 0x1 << 0
    static let SmallBall : UInt32 = 0x1 << 1
    static let MainBall : UInt32 = 0x1 << 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let MainBall = SKSpriteNode(imageNamed:"Ball")
    
    var EnemyTimer = NSTimer()
    
    var hits = 0
    var gameStarted = false
    
    
    var TTBLbl = SKLabelNode(fontNamed: "STHeitiJ-Medium")
    var ScoreLbl = SKLabelNode(fontNamed:  "STHeitiJ-Medium")
    var HighscoreLbl = SKLabelNode(fontNamed:  "STHeitiJ-Medium")
    
    
    var Score = 0
    var Highscore = 0
    
    var FadingAnim = SKAction()
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        let HighscoreDefault = NSUserDefaults.standardUserDefaults()
        if HighscoreDefault.valueForKey("Highscore") != nil {
            
            
            Highscore = HighscoreDefault.valueForKey("Highscore") as! Int
            HighscoreLbl.text = "Highscore : \(Highscore)"
            
        }
        
        TTBLbl.text = "Tap To Begin"
        TTBLbl.fontSize = 34
        TTBLbl.position = CGPoint(x: scene!.frame.width / 2, y: scene!.frame.height / 2)
        TTBLbl.fontColor = UIColor.whiteColor()
        TTBLbl.zPosition = 2.0
        self.addChild(TTBLbl)
        FadingAnim = SKAction.sequence([SKAction.fadeInWithDuration(1.0), SKAction.fadeOutWithDuration(1.0)])
        TTBLbl.runAction(SKAction.repeatActionForever(FadingAnim))
        
        HighscoreLbl.text = "Highscore : \(Highscore)"
        HighscoreLbl.position = CGPoint(x: scene!.frame.width / 2, y: scene!.frame.height / 1.3)
        HighscoreLbl.fontColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        self.addChild(HighscoreLbl)
        
        ScoreLbl.alpha = 0
        ScoreLbl.fontSize = 35
        ScoreLbl.position = CGPoint(x: scene!.frame.width / 2, y: scene!.frame.height / 1.3)
        ScoreLbl.fontColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        ScoreLbl.text = "\(Score)"
        self.addChild(ScoreLbl)
        
        
        
        
        
        backgroundColor = UIColor.whiteColor()
        
        MainBall.size = CGSize(width: 225,height: 225)
        MainBall.position = CGPoint(x: scene!.frame.width / 2, y: scene!.frame.height / 2)
        MainBall.color = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        MainBall.colorBlendFactor = 1.0
        MainBall.zPosition = 1.0
        
        MainBall.physicsBody = SKPhysicsBody(circleOfRadius: MainBall.size.width / 2)
        MainBall.physicsBody?.categoryBitMask   = PhysicsCatagory.MainBall
        MainBall.physicsBody?.collisionBitMask = PhysicsCatagory.Enemy
        MainBall.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
        MainBall.physicsBody?.affectedByGravity = false
        MainBall.physicsBody?.dynamic = false
        
        MainBall.name = "MainBall"

        self.addChild(MainBall)

           }
    
    
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node != nil && contact.bodyB.node != nil{
            let firstBody = contact.bodyA.node as! SKSpriteNode
            let secondBody = contact.bodyB.node as! SKSpriteNode
            
            if ((firstBody.name == "Enemy") && (secondBody.name == "SmallBall")){
                
                collisionBullet(firstBody, SmallBall: secondBody)
            }
            else if ((firstBody.name == "SmallBall") && (secondBody.name == "Enemy")){
                
                collisionBullet(secondBody, SmallBall: firstBody)
                
            }
            else if ((firstBody.name == "MainBall") && (secondBody.name == "Enemy")){
                
                collisionMain(secondBody)
                
            }
            else if ((firstBody.name == "Enemy") && (secondBody.name == "MainBall")){
                
               collisionMain(firstBody)
                
            }
        
        }
        
    }
    
    func collisionMain(Enemy : SKSpriteNode){
        if hits < 2 {
            MainBall.runAction(SKAction.scaleBy(1.5, duration: 0.4))
            Enemy.physicsBody?.affectedByGravity = true
            Enemy.removeAllActions()
            MainBall.runAction(SKAction.sequence([SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.1), SKAction.colorizeWithColor(SKColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0), colorBlendFactor: 1.0, duration: 0.1)]))
            hits++
            Enemy.removeFromParent()
            
            
        }
        
        else{
            Enemy.removeFromParent()
            EnemyTimer.invalidate()
            gameStarted = false
            
            ScoreLbl.runAction(SKAction.fadeOutWithDuration(0.2))
            TTBLbl.runAction(SKAction.fadeInWithDuration(1.0))
            TTBLbl.runAction(SKAction.repeatActionForever(FadingAnim))
            HighscoreLbl.runAction(SKAction.fadeInWithDuration(0.2))
            
            if Score > Highscore {
                let HighscoreDefault = NSUserDefaults.standardUserDefaults()
                Highscore = Score
                HighscoreDefault.setInteger(Highscore, forKey: "Highscore")
                HighscoreLbl.text = "Highscore : \(Highscore)"
                
            }
            
            
            
            
            }
    }
    
    
    
    func collisionBullet(Enemy : SKSpriteNode, SmallBall : SKSpriteNode){
        Enemy.physicsBody?.dynamic = true
        
        Enemy.physicsBody?.affectedByGravity = true
        
        Enemy.physicsBody?.mass = 5.0
        SmallBall.physicsBody?.mass = 5.0
        
        Enemy.removeAllActions()
        SmallBall.removeAllActions()
        Enemy.physicsBody?.contactTestBitMask = 0
        Enemy.physicsBody?.collisionBitMask = 0
        Enemy.name = nil
        
        Score++
        ScoreLbl.text = "\(Score)"
        
    }
    
    

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        if gameStarted == false {
            EnemyTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("Enemies"), userInfo: nil, repeats: true)
            gameStarted = true
            MainBall.runAction(SKAction.scaleTo(0.44, duration: 0.2))
            hits = 0
            
            
            TTBLbl.removeAllActions()
            TTBLbl.runAction(SKAction.fadeOutWithDuration(0.2))
            HighscoreLbl.runAction(SKAction.fadeOutWithDuration(0.2))
            
            ScoreLbl.runAction(SKAction.sequence([SKAction.waitForDuration(1.0), SKAction.fadeInWithDuration(1.0)]))
            
            Score = 0
            ScoreLbl.text = "\(Score)"
            
        }
        else{
        
        for touch in (touches as! Set<UITouch>) {
            let location = touch.locationInNode(self)
            
            let SmallBall = SKSpriteNode(imageNamed:"Ball")
            SmallBall.zPosition = -1.0
            SmallBall.size = CGSizeMake(20, 20)
            SmallBall.position = MainBall.position
            SmallBall.physicsBody = SKPhysicsBody(circleOfRadius: SmallBall.size.width / 2)
            SmallBall.color = UIColor(red: 0.1, green: 0.85, blue: 0.95, alpha: 1.0)
            SmallBall.colorBlendFactor = 1.0
            
            
            SmallBall.physicsBody?.categoryBitMask = PhysicsCatagory.SmallBall
            SmallBall.physicsBody?.collisionBitMask = PhysicsCatagory.Enemy
            SmallBall.physicsBody?.contactTestBitMask = PhysicsCatagory.Enemy
            SmallBall.name = "SmallBall"
            SmallBall.physicsBody?.dynamic = true
            SmallBall.physicsBody?.affectedByGravity = true
            
            
            var dx = CGFloat(location.x - MainBall.position.x)
            var dy = CGFloat(location.y - MainBall.position.y)
            

            let magnitude = sqrt(dx * dx + dy * dy)
            
            dx /= magnitude
            dy /= magnitude
            
            self.addChild(SmallBall)
            
            let vector = CGVectorMake(16.0 * dx, 16.0 * dy)
            
            SmallBall.physicsBody?.applyImpulse(vector)
            
            }
        }
    }
    
    func Enemies(){
        let Enemy = SKSpriteNode(imageNamed: "Ball")
        Enemy.size = CGSize(width: 20, height: 20)
        Enemy.color = UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)
        Enemy.colorBlendFactor = 1.0

        
        //Physics
        Enemy.physicsBody = SKPhysicsBody(circleOfRadius: Enemy.size.width / 2)
        Enemy.physicsBody?.categoryBitMask = PhysicsCatagory.Enemy
        Enemy.physicsBody?.contactTestBitMask = PhysicsCatagory.SmallBall | PhysicsCatagory.MainBall
        Enemy.physicsBody?.collisionBitMask = PhysicsCatagory.SmallBall | PhysicsCatagory.MainBall
        Enemy.physicsBody?.affectedByGravity = false
        Enemy.physicsBody?.dynamic = true
        Enemy.name = "Enemy"
        
        
        
        
        let RandomPosNmbr = arc4random() % 4
        
        switch RandomPosNmbr{
        case 0:
            
            Enemy.position.x = 0
            
            var PositionY = arc4random_uniform(UInt32(frame.size.height))
            
            Enemy.position.y = CGFloat(PositionY)
            
            self.addChild(Enemy)
            
            break
        case 1:
            
            Enemy.position.y = 0
            
            var PositionX = arc4random_uniform(UInt32(frame.size.width))
            
            Enemy.position.x = CGFloat(PositionX)
            
            self.addChild(Enemy)

            break
        case 2:
            
            Enemy.position.y = frame.size.height
            
            var PositionX = arc4random_uniform(UInt32(frame.size.width))
            
            Enemy.position.x = CGFloat(PositionX)
            
            self.addChild(Enemy)
            
            break
        case 3:
            
            Enemy.position.x = frame.size.width
            
            var PositionY = arc4random_uniform(UInt32(frame.size.height))
            
            Enemy.position.y = CGFloat(PositionY)
            
            self.addChild(Enemy)

            break
        default:
            
            break

        }
        
        
        
        Enemy.runAction(SKAction.moveTo(MainBall.position, duration: 3))
        
        
        
    }
    
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */ 
    }
}
