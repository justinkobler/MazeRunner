//
//  GameScene.swift
//  Maze Run
//
//  Created by Justin Kobler on 7/28/17.
//  Copyright © 2017 Justin Kobler Apps. All rights reserved.
//

import SpriteKit
import GameplayKit



struct PhysicsCategory {
    static let Player : UInt32 = 0x1 << 1
    static let Wall: UInt32 = 0x1 << 2
    static let Bound: UInt32 = 0x1 << 3
    static let BottomBound: UInt32 = 0x1 << 4
    static let Score: UInt32 = 0x1 << 5
    static let Score2: UInt32 = 0x1 << 6
}

var showAd = false

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var player = SKSpriteNode()
    var leftWall = SKSpriteNode()
    var rightWall = SKSpriteNode()
    var coin = SKSpriteNode()
    var moneyBag = SKSpriteNode()
    var wallPair = SKNode()
    
    var moveAndRemoveWalls = SKAction()
    var moveAndRemoveWalls1 = SKAction()
    var moveAndRemoveWalls2 = SKAction()
    var moveAndRemoveWalls3 = SKAction()
    var moveAndRemoveWalls4 = SKAction()
    var moveAndRemoveWalls5 = SKAction()
    var moveAndRemoveWalls6 = SKAction()
    var moveAndRemoveWalls7 = SKAction()
    var moveAndRemoveWalls8 = SKAction()
    var moveAndRemoveWalls9 = SKAction()
    var moveAndRemoveWalls10 = SKAction()
    
    
    var topBound = SKSpriteNode()
    var bottomBound = SKSpriteNode()
    var leftBound = SKSpriteNode()
    var rightBound = SKSpriteNode()
    
    var gameStarted = Bool()
    var died = Bool()
    var restartBTN = SKSpriteNode()
    
    var score = Int()
    let scoreLbl = SKLabelNode()
    var highScore = Int()
    let highScoreLbl = SKLabelNode()
    var startGameLbl = SKLabelNode()
    
    var pi = CGFloat(M_PI)
    
    var touchLocation = CGPoint()
    var falseTouchLocation = CGPoint()
    
    func displayMultiLineTextAt(x: CGFloat, y: CGFloat, align: SKLabelHorizontalAlignmentMode, lineHeight: CGFloat, text: String) {
        let textNode = SKNode()
        textNode.position = CGPoint(x: x, y: y)
        var lineAt: CGFloat = 0
        for line in text.components(separatedBy: "\n") {
            let labelNode = SKLabelNode(fontNamed: "Arial")
            labelNode.fontSize = 14
            labelNode.horizontalAlignmentMode = align
            labelNode.fontColor = SKColor(hue: 1, saturation: 1, brightness: 1, alpha: 1)
            labelNode.position = CGPoint(x: 0, y: lineAt)
            labelNode.text = line
            textNode.addChild(labelNode)
            lineAt -= lineHeight
        }
        scene!.addChild(textNode)
    }
    
    func restartScene() {
        self.removeAllChildren()
        self.removeAllActions()
        died = false
        gameStarted = false
        score = 0
        createScene()
    }
    
    func createScene() {
        self.physicsWorld.contactDelegate = self
        
        highScoreLbl.position = CGPoint(x: self.frame.width / 2 + 80, y: self.frame.height - 35)
        highScoreLbl.text = "High Score: \(highScore)"
        highScoreLbl.fontName = "Georgia"
        highScoreLbl.fontSize = 24
        highScoreLbl.zPosition = 12
        highScoreLbl.fontColor = SKColor.yellow
        self.addChild(highScoreLbl)
        
        scoreLbl.position = CGPoint(x: self.frame.width / 2 - 90, y: highScoreLbl.position.y)
        scoreLbl.text = "Score: \(score)"
        scoreLbl.fontName = "Georgia"
        scoreLbl.fontSize = 30
        scoreLbl.zPosition = 10
        scoreLbl.fontColor = SKColor.yellow
        self.addChild(scoreLbl)
        
        /*let base = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: 70))
        base.strokeColor = SKColor.red
        base.fillColor = SKColor.red
        base.position = CGPoint(x: self.frame.width / 2, y: 35)
        base.zPosition = 20
        self.addChild(base)*/
        
        let top = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: 50))
        top.strokeColor = SKColor.yellow
        top.fillColor = SKColor.gray
        top.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 25)
        top.zPosition = 5
        self.addChild(top)
        
        
        player = SKSpriteNode(imageNamed: "Cyan Circle")
        player.setScale(0.5)
        player.size = CGSize(width: 45, height: 45)
        player.color = SKColor.cyan
        player.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(circleOfRadius: 22)
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.collisionBitMask = PhysicsCategory.Wall | PhysicsCategory.Bound | PhysicsCategory.BottomBound
        player.physicsBody?.contactTestBitMask = PhysicsCategory.BottomBound | PhysicsCategory.Score
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
        self.addChild(player)
        
        topBound = SKSpriteNode()
        topBound.size = CGSize(width: self.frame.width, height: 1)
        topBound.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - 50)
        topBound.physicsBody = SKPhysicsBody(rectangleOf: topBound.size)
        topBound.physicsBody?.categoryBitMask = PhysicsCategory.Bound
        topBound.physicsBody?.collisionBitMask = PhysicsCategory.Player
        topBound.physicsBody?.contactTestBitMask = 0
        topBound.physicsBody?.affectedByGravity = false
        topBound.physicsBody?.isDynamic = false
        self.addChild(topBound)
        
        bottomBound = SKSpriteNode()
        bottomBound.size = CGSize(width: self.frame.width, height: 1)
        bottomBound.position = CGPoint(x: self.frame.width / 2, y: 70)
        bottomBound.physicsBody = SKPhysicsBody(rectangleOf: bottomBound.size)
        bottomBound.physicsBody?.categoryBitMask = PhysicsCategory.BottomBound
        bottomBound.physicsBody?.collisionBitMask = PhysicsCategory.Player
        bottomBound.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        bottomBound.physicsBody?.affectedByGravity = false
        bottomBound.physicsBody?.isDynamic = false
        self.addChild(bottomBound)
        
        leftBound = SKSpriteNode()
        leftBound.size = CGSize(width: 1, height: self.frame.height)
        leftBound.position = CGPoint(x: 0, y: self.frame.height / 2)
        leftBound.physicsBody = SKPhysicsBody(rectangleOf: leftBound.size)
        leftBound.physicsBody?.categoryBitMask = PhysicsCategory.Bound
        leftBound.physicsBody?.collisionBitMask = PhysicsCategory.Player
        leftBound.physicsBody?.contactTestBitMask = 0
        leftBound.physicsBody?.affectedByGravity = false
        leftBound.physicsBody?.isDynamic = false
        self.addChild(leftBound)
        
        rightBound = SKSpriteNode()
        rightBound.size = CGSize(width: 1, height: self.frame.height)
        rightBound.position = CGPoint(x: self.frame.width, y: self.frame.height / 2)
        rightBound.physicsBody = SKPhysicsBody(rectangleOf: rightBound.size)
        rightBound.physicsBody?.categoryBitMask = PhysicsCategory.Bound
        rightBound.physicsBody?.collisionBitMask = PhysicsCategory.Player
        rightBound.physicsBody?.contactTestBitMask = 0
        rightBound.physicsBody?.affectedByGravity = false
        rightBound.physicsBody?.isDynamic = false
        self.addChild(rightBound)
        
        startGameLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + player.size.height * 2)
        startGameLbl.text = "Touch Screen to Start"
        startGameLbl.fontName = "Arial"
        startGameLbl.fontSize = 30
        startGameLbl.zPosition = 15
        startGameLbl.fontColor = SKColor.lightGray
        startGameLbl.run(SKAction.scale(to: 1, duration: 0.3))
        self.addChild(startGameLbl)
        
    }
    
    func createWalls() {
        coin = SKSpriteNode(imageNamed: "Coin")
        coin.setScale(0.5)
        coin.position = CGPoint(x: self.frame.width / 2, y: self.frame.height + 120)
        coin.physicsBody = SKPhysicsBody(rectangleOf: coin.size)
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Score
        coin.physicsBody?.collisionBitMask = 0
        coin.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.isDynamic = false
        
        moneyBag = SKSpriteNode(imageNamed: "Moneybag")
        moneyBag.setScale(0.5)
        moneyBag.position = CGPoint(x: self.frame.width / 2, y: self.frame.height + 120)
        moneyBag.physicsBody = SKPhysicsBody(rectangleOf: moneyBag.size)
        moneyBag.physicsBody?.categoryBitMask = PhysicsCategory.Score2
        moneyBag.physicsBody?.collisionBitMask = 0
        moneyBag.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        moneyBag.physicsBody?.affectedByGravity = false
        moneyBag.physicsBody?.isDynamic = false
        
        wallPair = SKNode()
        
        leftWall = SKSpriteNode(imageNamed: "Wall")
        leftWall.position = CGPoint(x: self.frame.width / 2 - 285, y: self.frame.height + 25)
        leftWall.setScale(0.5)
        leftWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Wall"), size: leftWall.size)
        leftWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        leftWall.physicsBody?.collisionBitMask = PhysicsCategory.Player
        leftWall.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        leftWall.physicsBody?.affectedByGravity = false
        leftWall.physicsBody?.isDynamic = false
        
        
        rightWall = SKSpriteNode(imageNamed: "Wall")
        rightWall.position = CGPoint(x: self.frame.width / 2 + 285, y: self.frame.height + 25)
        rightWall.setScale(0.5)
        rightWall.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "Wall"), size: rightWall.size)
        rightWall.physicsBody?.categoryBitMask = PhysicsCategory.Wall
        rightWall.physicsBody?.collisionBitMask = PhysicsCategory.Player
        rightWall.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        rightWall.physicsBody?.affectedByGravity = false
        rightWall.physicsBody?.isDynamic = false
        
        
        wallPair.addChild(leftWall)
        wallPair.addChild(rightWall)
        wallPair.zPosition = 3
        var randomPosition = CGFloat.random(min: -140, max: 140)
        var randomPosition2 = CGFloat.random(min: -self.frame.width/2, max: self.frame.width/2)
        wallPair.position.x = wallPair.position.x + randomPosition
        coin.position.x = coin.position.x + randomPosition2
        moneyBag.position.x = moneyBag.position.x + randomPosition2
        //wallPair.run(moveAndRemoveWalls)
        //coin.run(moveAndRemoveWalls)
        //moneyBag.run(moveAndRemoveWalls)
        
        wallPair.run(moveAndRemoveWalls)
        coin.run(moveAndRemoveWalls)
        moneyBag.run(moveAndRemoveWalls)
        
        /*if score >= 10 && score < 20 {
            wallPair.run(moveAndRemoveWalls1)
            coin.run(moveAndRemoveWalls1)
            moneyBag.run(moveAndRemoveWalls1)
        }
        else if score >= 20 {
            wallPair.run(moveAndRemoveWalls2)
            coin.run(moveAndRemoveWalls2)
            moneyBag.run(moveAndRemoveWalls2)
        }
        else if score >= 15 && score < 20 {
            wallPair.run(moveAndRemoveWalls3)
            coin.run(moveAndRemoveWalls3)
            moneyBag.run(moveAndRemoveWalls3)
        }
        else if score >= 20 && score < 25 {
            wallPair.run(moveAndRemoveWalls4)
            coin.run(moveAndRemoveWalls4)
            moneyBag.run(moveAndRemoveWalls4)
        }
        else if score >= 25 && score < 30 {
            wallPair.run(moveAndRemoveWalls5)
            coin.run(moveAndRemoveWalls5)
            moneyBag.run(moveAndRemoveWalls5)
        }
        else if score >= 30 && score < 35 {
            wallPair.run(moveAndRemoveWalls6)
            coin.run(moveAndRemoveWalls6)
            moneyBag.run(moveAndRemoveWalls6)
        }
        else if score >= 35 && score < 40 {
            wallPair.run(moveAndRemoveWalls7)
            coin.run(moveAndRemoveWalls7)
            moneyBag.run(moveAndRemoveWalls7)
        }
        else if score >= 40 && score < 45 {
            wallPair.run(moveAndRemoveWalls8)
            coin.run(moveAndRemoveWalls8)
            moneyBag.run(moveAndRemoveWalls8)
        }
        else if score >= 45 && score < 50 {
            wallPair.run(moveAndRemoveWalls9)
            coin.run(moveAndRemoveWalls9)
            moneyBag.run(moveAndRemoveWalls9)
        }
        else if score >= 50 {
            wallPair.run(moveAndRemoveWalls10)
            coin.run(moveAndRemoveWalls10)
            moneyBag.run(moveAndRemoveWalls10)
        }*/
        self.addChild(wallPair)
        let chooseMoney = arc4random_uniform(42)
        if chooseMoney < 18 {
            self.addChild(coin)
        }
        else if chooseMoney > 40 {
            self.addChild(moneyBag)
        }
    }
    
    func createBTN() {
        restartBTN = SKSpriteNode(imageNamed: "Restart Button")
        restartBTN.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBTN.zPosition = 11
        restartBTN.setScale(0)
        self.addChild(restartBTN)
        
        restartBTN.run(SKAction.scale(to: 0.5, duration: 0.5))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody = contact.bodyA
        let secondBody = contact.bodyB
        
        if firstBody.categoryBitMask == PhysicsCategory.Score && secondBody.categoryBitMask == PhysicsCategory.Player || firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Score {
            
            score += 1
            scoreLbl.text = "Score: \(score)"
            if firstBody.categoryBitMask == PhysicsCategory.Score {
                firstBody.node?.removeFromParent()
            }
            else {
                secondBody.node?.removeFromParent()
            }
            
            if score > highScore {
                highScore = score
                highScoreLbl.text = "High Score: \(highScore)"
                
                var highScoreDefault = UserDefaults.standard
                highScoreDefault.setValue(highScore, forKey: "highScore")
                highScoreDefault.synchronize()
                
            }
            
        }
            
        else if firstBody.categoryBitMask == PhysicsCategory.Score2 && secondBody.categoryBitMask == PhysicsCategory.Player || firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Score2 {
            
            score += 5
            scoreLbl.text = "Score: \(score)"
            if firstBody.categoryBitMask == PhysicsCategory.Score2 {
                firstBody.node?.removeFromParent()
            }
            else {
                secondBody.node?.removeFromParent()
            }
            
            if score > highScore {
                highScore = score
                highScoreLbl.text = "High Score: \(highScore)"
                
                var highScoreDefault = UserDefaults.standard
                highScoreDefault.setValue(highScore, forKey: "highScore")
                highScoreDefault.synchronize()
                
            }
            
        }
        
        else if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Wall || firstBody.categoryBitMask == PhysicsCategory.Wall && secondBody.categoryBitMask == PhysicsCategory.Player /*|| firstBody.categoryBitMask == PhysicsCategory.Bird && secondBody.categoryBitMask == PhysicsCategory.Plane || firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Bird || firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.Ground || firstBody.categoryBitMask == PhysicsCategory.Ground && secondBody.categoryBitMask == PhysicsCategory.Player */{
            
            showAd = true
            print("showAd = \(showAd)")

            enumerateChildNodes(withName: "wallPair", using: ({
                (node, error) in
                
                node.speed = 0
                self.removeAllActions()
                
            }))
            if died == false {
                died = true
                createBTN()
            }
        }
        
        else if firstBody.categoryBitMask == PhysicsCategory.Player && secondBody.categoryBitMask == PhysicsCategory.BottomBound || firstBody.categoryBitMask == PhysicsCategory.BottomBound && secondBody.categoryBitMask == PhysicsCategory.Player {
            
            player.removeFromParent()
            
        }
        
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        var highScoreDefault = UserDefaults.standard
        
        if (highScoreDefault.value(forKey: "highScore") != nil) {
            highScore = highScoreDefault.value(forKey: "highScore") as! NSInteger!
            highScoreLbl.text = NSString(format: "High Score: \(highScore)" as NSString, highScore) as String
        }
        
        createScene()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            touchLocation = touch.location(in: self)
            
            if touchLocation.x < player.position.x + 50 && touchLocation.x > player.position.x - 50 {
                player.position.x = touchLocation.x
                
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        showAd = false
        print("showAd = \(showAd)")

        if gameStarted == false {
            gameStarted = true
            
            
            startGameLbl.run(SKAction.scale(to: 0, duration: 0.3))
            
            let spawn = SKAction.run({
                () in
                
                self.createWalls()
                
            })
            
            let delay = SKAction.wait(forDuration: 0.8)
            /*let delay1 = SKAction.wait(forDuration: 0.4)
            let delay2 = SKAction.wait(forDuration: 0.3)
            let delay3 = SKAction.wait(forDuration: 0.55)
            let delay4 = SKAction.wait(forDuration: 0.5)
            let delay5 = SKAction.wait(forDuration: 0.45)
            let delay6 = SKAction.wait(forDuration: 0.4)
            let delay7 = SKAction.wait(forDuration: 0.35)
            let delay8 = SKAction.wait(forDuration: 0.3)
            let delay9 = SKAction.wait(forDuration: 0.25)
            let delay10 = SKAction.wait(forDuration: 0.2)*/
            
            
            let SpawnDelay = SKAction.sequence([delay, spawn])
            /*let SpawnDelay1 = SKAction.sequence([spawn, delay1])
            let SpawnDelay2 = SKAction.sequence([spawn, delay2])
            let SpawnDelay3 = SKAction.sequence([spawn, delay3])
            let SpawnDelay4 = SKAction.sequence([spawn, delay4])
            let SpawnDelay5 = SKAction.sequence([spawn, delay5])
            let SpawnDelay6 = SKAction.sequence([spawn, delay6])
            let SpawnDelay7 = SKAction.sequence([spawn, delay7])
            let SpawnDelay8 = SKAction.sequence([spawn, delay8])
            let SpawnDelay9 = SKAction.sequence([spawn, delay9])
            let SpawnDelay10 = SKAction.sequence([spawn, delay10])*/
            
            let SpawnDelayForever = SKAction.repeatForever(SpawnDelay)
            /*let SpawnDelayForever1 = SKAction.repeatForever(SpawnDelay1)
            let SpawnDelayForever2 = SKAction.repeatForever(SpawnDelay2)
            let SpawnDelayForever3 = SKAction.repeatForever(SpawnDelay3)
            let SpawnDelayForever4 = SKAction.repeatForever(SpawnDelay4)
            let SpawnDelayForever5 = SKAction.repeatForever(SpawnDelay5)
            let SpawnDelayForever6 = SKAction.repeatForever(SpawnDelay6)
            let SpawnDelayForever7 = SKAction.repeatForever(SpawnDelay7)
            let SpawnDelayForever8 = SKAction.repeatForever(SpawnDelay8)
            let SpawnDelayForever9 = SKAction.repeatForever(SpawnDelay9)
            let SpawnDelayForever10 = SKAction.repeatForever(SpawnDelay10)*/
            
            self.run(SpawnDelayForever)
            
            /*else if score >= 10 && score < 20 {
                self.run(SpawnDelayForever1)
            }
            else if score >= 20 {
                self.run(SpawnDelayForever2)
            }
            else if score >= 15 && score < 20 {
                self.run(SpawnDelayForever3)
            }
            else if score >= 20 && score < 25 {
                self.run(SpawnDelayForever4)
            }
            else if score >= 25 && score < 30 {
                self.run(SpawnDelayForever5)
            }
            else if score >= 30 && score < 35 {
                self.run(SpawnDelayForever6)
            }
            else if score >= 35 && score < 40 {
                self.run(SpawnDelayForever7)
            }
            else if score >= 40 && score < 45 {
                self.run(SpawnDelayForever8)
            }
            else if score >= 45 && score < 50 {
                self.run(SpawnDelayForever9)
            }
            else if score >= 50 {
                self.run(SpawnDelayForever10)
            }*/
            
            
            
            let distance = CGFloat(self.frame.height + wallPair.frame.height)
            let moveWalls = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.004 * distance))
            /*let moveWalls1 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.0045 * distance))
            let moveWalls2 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.004 * distance))
            let moveWalls3 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.0055 * distance))
            let moveWalls4 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.005 * distance))
            let moveWalls5 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.0045 * distance))
            let moveWalls6 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.004 * distance))
            let moveWalls7 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.0035 * distance))
            let moveWalls8 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.003 * distance))
            let moveWalls9 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.0025 * distance))
            let moveWalls10 = SKAction.moveBy(x: 0, y: -distance, duration: TimeInterval(0.002 * distance))
            
            
             let rnd1 = Int(arc4random_uniform(5)) - 2
             let random1 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd1)
             let rnd2 = Int(arc4random_uniform(5)) - 2
             let random2 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd2)
             let rnd3 = Int(arc4random_uniform(5)) - 2
             let random3 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd3)
             let rnd4 = Int(arc4random_uniform(5)) - 2
             let random4 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd4)
             let rnd5 = Int(arc4random_uniform(5)) - 2
             let random5 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd5)
             let moveBirds1 = SKAction.moveBy(x: -distance / 3, y: distance * random1 / 4, duration: TimeInterval(0.0015 * distance))
             let moveBirds2 = SKAction.moveBy(x: -distance / 3, y: distance * random2 / 4, duration: TimeInterval(0.0015 * distance))
             let moveBirds3 = SKAction.moveBy(x: -distance / 3 - 50, y: distance * random3 / 4, duration: TimeInterval(0.0015 * distance))
             let moveBirds4 = SKAction.moveBy(x: -distance / 5, y: distance * random1 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds5 = SKAction.moveBy(x: -distance / 5, y: distance * random2 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds6 = SKAction.moveBy(x: -distance / 5, y: distance * random3 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds7 = SKAction.moveBy(x: -distance / 5, y: distance * random4 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds8 = SKAction.moveBy(x: -distance / 5 - 50, y: distance * random5 / 3, duration: TimeInterval(0.0008 * distance))*/
            
            let removeEnemies = SKAction.removeFromParent()
            moveAndRemoveWalls = SKAction.sequence([moveWalls, removeEnemies])
            /*moveAndRemoveWalls1 = SKAction.sequence([moveWalls1, removeEnemies])
            moveAndRemoveWalls2 = SKAction.sequence([moveWalls2, removeEnemies])
            moveAndRemoveWalls3 = SKAction.sequence([moveWalls3, removeEnemies])
            moveAndRemoveWalls4 = SKAction.sequence([moveWalls4, removeEnemies])
            moveAndRemoveWalls5 = SKAction.sequence([moveWalls5, removeEnemies])
            moveAndRemoveWalls6 = SKAction.sequence([moveWalls6, removeEnemies])
            moveAndRemoveWalls7 = SKAction.sequence([moveWalls7, removeEnemies])
            moveAndRemoveWalls8 = SKAction.sequence([moveWalls8, removeEnemies])
            moveAndRemoveWalls9 = SKAction.sequence([moveWalls9, removeEnemies])
            moveAndRemoveWalls10 = SKAction.sequence([moveWalls10, removeEnemies])*/
            
            /*moveAndRemoveBirds = SKAction.sequence([moveBirds1, moveBirds2, moveBirds3, removeEnemies])
             moveAndRemoveBirds2 = SKAction.sequence([moveBirds4, moveBirds5, moveBirds6, moveBirds7, moveBirds8, removeEnemies])*/
            
            
            
        }
        else {
            /*if died == true {
             
             }
             
             else {
             
             
             let distance = CGFloat(self.frame.width + wallPair.frame.width)
             let rnd1 = Int(arc4random_uniform(5)) - 2
             let random1 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd1)
             let rnd2 = Int(arc4random_uniform(5)) - 2
             let random2 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd2)
             let rnd3 = Int(arc4random_uniform(5)) - 2
             let random3 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd3)
             let rnd4 = Int(arc4random_uniform(5)) - 2
             let random4 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd4)
             let rnd5 = Int(arc4random_uniform(5)) - 2
             let random5 = (CGFloat(Float(arc4random()) / Float(UINT32_MAX))) * CGFloat(rnd5)
             let moveBirds1 = SKAction.moveBy(x: -distance / 3, y: distance * random1 / 4, duration: TimeInterval(0.0015 * distance))
             let moveBirds2 = SKAction.moveBy(x: -distance / 3, y: distance * random2 / 4, duration: TimeInterval(0.0015 * distance))
             let moveBirds3 = SKAction.moveBy(x: -distance / 3 - 50, y: distance * random3 / 4, duration: TimeInterval(0.0015 * distance))
             let moveBirds4 = SKAction.moveBy(x: -distance / 5, y: distance * random1 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds5 = SKAction.moveBy(x: -distance / 5, y: distance * random2 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds6 = SKAction.moveBy(x: -distance / 5, y: distance * random3 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds7 = SKAction.moveBy(x: -distance / 5, y: distance * random4 / 3, duration: TimeInterval(0.0008 * distance))
             let moveBirds8 = SKAction.moveBy(x: -distance / 5 - 50, y: distance * random5 / 3, duration: TimeInterval(0.0008 * distance))
             let removeEnemies = SKAction.removeFromParent()
             moveAndRemoveBirds = SKAction.sequence([moveBirds1, moveBirds2, moveBirds3, removeEnemies])
             moveAndRemoveBirds2 = SKAction.sequence([moveBirds4, moveBirds5, moveBirds6, moveBirds7, moveBirds8, removeEnemies])
             }
             }*/
            
            for touch in touches {
                let location = touch.location(in: self)

                if died == true {
                    if restartBTN.contains(location) {
                        restartScene()
                        showAd = true
                        print("showAd = \(showAd)")
                    }
                }
            }
            
        }
        
    }
}
