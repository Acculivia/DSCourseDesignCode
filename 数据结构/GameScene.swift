//
//  GameScene.swift
//  数据结构
//
//  Created by AlterTaceo on 16/6/8.
//  Copyright (c) 2016年 test. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let barAmount:CGFloat = 4
    
    var leftPosition:CGFloat = 0
    var rightPosition:CGFloat = 0
    
    var selectedBar:Int? = nil
    
    var bars = [SKShapeNode]()
    var signs = [(start:Int, end:Int, position:CGFloat, sign:SKShapeNode)]()
    
    let clear = SKLabelNode(text: "Clear")
    let run = SKLabelNode(text: "Run")
    var selectShape = SKShapeNode()
    
    override func didMoveToView(view: SKView) {
        for i in 1...Int(barAmount){
            let bar = SKShapeNode(rectOfSize: CGSizeMake(30, size.height - 300))
            bar.name = "bar"
            bar.position = CGPointMake(size.width / (barAmount + 1) * CGFloat(i),size.height / 2 + 100)
            bar.fillColor = UIColor.whiteColor()
            bar.zPosition = 1
            self.addChild(bar)
            bars.append(bar)
        }
        leftPosition = bars[0].position.x
        rightPosition = bars[Int(barAmount)-1].position.x
        
        selectShape = SKShapeNode(rectOfSize: CGSizeMake(50, size.height - 200))
        selectShape.alpha = 0
        self.addChild(selectShape)
        
        clear.verticalAlignmentMode = .Center
        clear.fontSize = 50
        clear.name = "Control"
        clear.position = CGPointMake(200, 100)
        self.addChild(clear)
        
        run.verticalAlignmentMode = .Center
        run.fontSize = 50
        run.name = "Control"
        run.position = CGPointMake(size.width - 200, 100)
        self.addChild(run)
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let location = touches.first!.locationInNode(self)
        let split = (rightPosition - leftPosition) / CGFloat(barAmount - 1)
        let index = Int(location.x + 15 - leftPosition) / Int(split)
        let node = nodeAtPoint(location)
        if(node.name != nil){
            switch node.name!{
                
            case "Control":
                controlAccordingToNode(node as! SKLabelNode)
                
            case "bar":
                print(index)
                selectedBar = index
                selectShape.position = nodeAtPoint(location).position
                selectShape.alpha = 1
                
            default:
                break
            }
        }else{
            if(location.x >= leftPosition && location.x <= rightPosition && location.y >= 300 && location.y <= size.height - 100){
                let sign = SKShapeNode(rectOfSize: CGSizeMake(split, 30))
                sign.fillColor = UIColor.grayColor()
                sign.name = "sign"
                sign.position = CGPointMake(CGFloat(index) * split + split / 2 + leftPosition, location.y)
                sign.zPosition = 0
                self.addChild(sign)
                signs.append((start:index, end:index+1, position:location.y, sign:sign))
            }
        }
    }
    
    func controlAccordingToNode(node: SKLabelNode){
        switch(node){
            
        case clear:
            self.removeChildrenInArray(signs.map({ (a:(start: Int, end: Int, position: CGFloat, sign: SKShapeNode)) -> SKNode in
                a.sign
            }))
            selectShape.alpha = 0
            selectedBar = nil
            signs = [(start:Int, end:Int, position:CGFloat, sign:SKShapeNode)]()
            
            for bar in bars{bar.fillColor = UIColor.whiteColor()}
            
        case run:
            findRoad()
            
        default:
            break
        }
    }
    
    func findRoad(){
        guard let _ = selectedBar else{print("No bar selected");return}
        
        var results = [SKShapeNode]()
        signs = (signs.sort{(a:(start: Int, end: Int, position: CGFloat, sign: SKShapeNode), b:(start: Int, end: Int, position: CGFloat, sign: SKShapeNode)) -> Bool in
            a.position > b.position})
        
        var l = [Int]()
        
        for i in 0..<signs.count{
            for j in 0..<signs.count{
                if abs(signs[i].position - signs[j].position) <= 10{
                    if signs[i].start == signs[j].end || signs[j].start == signs[i].end{
                        if !l.contains(i){l.append(i)}
                        if !l.contains(j){l.append(j)}
                    }
                }
            }
        }
        
        for i in l{
            signs[i].position = -99999
        }
        
        signs = (signs.sort{(a:(start: Int, end: Int, position: CGFloat, sign: SKShapeNode), b:(start: Int, end: Int, position: CGFloat, sign: SKShapeNode)) -> Bool in
            a.position > b.position})
        
        for i in signs{
            print(i.position)
        }
        
        var index = selectedBar!
        
        for bar in signs{
            if bar.position == -99999{break}
            if(bar.start == index){
                results.append(bar.sign)
                index = bar.end
            }else if(bar.end == index){
                results.append(bar.sign)
                index = bar.start
            }
        }
        
        for bar in results{
            bar.fillColor = UIColor.yellowColor()
        }
        bars[index].fillColor = UIColor.greenColor()
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
