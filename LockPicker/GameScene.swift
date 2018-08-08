//
//  GameScene.swift
//  LockPicker
//
//  Created by Snorre Kristoffer Widnes on 05/01/16.
//  Copyright (c) 2016 Snorre Kristoffer Widnes. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var Circle = SKSpriteNode()
    var Person = SKSpriteNode()
    var Path = UIBezierPath()
    var GameStarted = Bool()
    var movingClockwise = Bool()
    var Dot = SKSpriteNode()
    var Intersected = false
    var levelLabel = UILabel()
    var currentLevel = Int()
    var highLevel = Int()
    var currentScore = Int()
    
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        loadView()
        let defaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults!
        if defaults.integerForKey("HighLevel") != 0{
        highLevel = defaults.integerForKey("HighLevel") as Int!
            currentLevel = highLevel
            currentScore = currentLevel
        levelLabel.text = "\(currentScore)"
        }
        else{
        defaults.setInteger(1, forKey: "HighLevel")
        }
        
    }
    
    func loadView(){
        
        movingClockwise = true
        backgroundColor = SKColor.whiteColor()
        
        Circle = SKSpriteNode(imageNamed: "Circle")
        Circle.size = CGSize(width: self.frame.width / 2.5 , height: self.frame.width / 2.5 )
        Circle.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.addChild(Circle)
        
        Circle.zPosition = 1
        
        Person = SKSpriteNode(imageNamed: "Person")
        Person.size = CGSize(width: self.frame.width / 27, height: 10)
        Person.position = CGPoint(x: self.frame.width / 2 ,  y: self.frame.height / 2 + 181)
        Person.zRotation = 3.14 / 2
        self.addChild(Person)
        
        Person.zPosition = 3
        
        levelLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 800))
        levelLabel.textColor = SKColor.darkGrayColor()
        levelLabel.text = "\(currentScore)"
        levelLabel.center = (self.view?.center)!
        levelLabel.textAlignment = NSTextAlignment.Center
        levelLabel.font = UIFont(name: "Hello World", size: 200)
            self.view?.addSubview(levelLabel)
        
        
        
        AddDot()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        if GameStarted == false{
            
            moveClockWise()
            movingClockwise = true
            GameStarted = true
        
        
        }
        else if GameStarted == true{
         
            
            if movingClockwise == true{
            moveCounterClockWise()
                movingClockwise = false
            
                
            }
            else if movingClockwise == false{
                moveClockWise()
                
                movingClockwise = true
            
                
                
            }
        
         dotTouched()
        
        }
        
        
    }
    
    func AddDot(){
    
    Dot = SKSpriteNode(imageNamed: "Dot")
        Dot.size = CGSize(width: 35, height: 35)
       
        Dot.zPosition = 2
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        let rad = atan2(dy , dx)
        
        if movingClockwise == true{
            
            let tempAngle = CGFloat.random(min: rad - 1.0, max: rad - 2.5)
                let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2 ), radius: 181, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
                Dot.position = path2.currentPoint
        }
            
        else if movingClockwise == false{
            
            let tempAngle = CGFloat.random(min: rad + 1.0, max: rad + 2.5)
            let path2 = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 ), radius: 181, startAngle: tempAngle, endAngle: tempAngle + CGFloat(M_PI * 4), clockwise: true)
            Dot.position = path2.currentPoint
        
        }
    self.addChild(Dot)    }
    
    
    func moveClockWise(){
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        let rad = atan2(dy , dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2), radius: 181, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow).reversedAction())
        
        
    
    }
    func moveCounterClockWise(){
        
        let dx = Person.position.x - self.frame.width / 2
        let dy = Person.position.y - self.frame.height / 2
        let rad = atan2(dy , dx)
        Path = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2 , y: self.frame.height / 2), radius: 181, startAngle: rad, endAngle: rad + CGFloat(M_PI * 4), clockwise: true)
        let follow = SKAction.followPath(Path.CGPath, asOffset: false, orientToPath: true, speed: 200)
        Person.runAction(SKAction.repeatActionForever(follow))
    }
    
    
    
    func dotTouched(){
        if Intersected == true{
        Dot.removeFromParent()
            AddDot()
            Intersected = false
            
            
        currentScore -= 1
            levelLabel.text = "\(currentScore)"
            if currentScore <= 0{
                nextLevel()
            
            }
        
        }
        else if Intersected == false{
        died()
        }
    }
    
    func nextLevel(){
    currentLevel += 1
        currentScore = currentLevel
        levelLabel.text = "\(currentScore)"
    won()
        if currentLevel > highLevel{
        highLevel = currentLevel
            let Defaults = NSUserDefaults.standardUserDefaults()
            Defaults.setInteger(highLevel, forKey: "HighLevel")
        
        
        }
    }
    
    
    
    func died(){
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor() , colorBlendFactor: 1, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        levelLabel.removeFromSuperview()
        currentScore = currentLevel
        Intersected = false
        GameStarted = false
        self.loadView()
    }
    func won(){
        self.removeAllChildren()
        let action1 = SKAction.colorizeWithColor(UIColor.greenColor(), colorBlendFactor: 1, duration: 0.2)
        let action2 = SKAction.colorizeWithColor(UIColor.whiteColor() , colorBlendFactor: 1, duration: 0.2)
        self.scene?.runAction(SKAction.sequence([action1,action2]))
        levelLabel.removeFromSuperview()
        Intersected = false
        GameStarted = false
        self.loadView()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if Person.intersectsNode(Dot){
            
        Intersected = true
            
        }
        else{
            if Intersected == true{
                if Person.intersectsNode(Dot) == false{
               died()
                }
            
            }
        
        
        
            
        
        
        
        
        
        
        
        }
    }
}
