//
//  OverlayScene.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 21.07.2023.
//

import Foundation
import Cocoa
import SceneKit
import SpriteKit

class OverlayScene: SKScene {
    private var progressViewNode: SKSpriteNode?
    private var progress: CGFloat = 0
    private var bgProgressNode: SKShapeNode?
    private var progressNode: SKShapeNode?
    private var gameInfoNode: GameInfoNode?
    
    var isHelpAction: (() -> Void)?
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // ignore
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        initScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initScene()
    }

    private func initScene(){
        scaleMode = .resizeFill
        
        //Progress
        progressViewNode = SKSpriteNode(color: .gray, size: .zero)
        progressViewNode?.alpha = 1
        if let progressViewNode = progressViewNode {
            addChild(progressViewNode)
        }
        
        bgProgressNode = SKShapeNode()
        if let bgProgressNode = bgProgressNode {
            progressViewNode?.addChild(bgProgressNode)
        }
        progressNode = SKShapeNode()
        if let progressNode = progressNode {
            progressViewNode?.addChild(progressNode)
        }
        
        //info
        gameInfoNode = GameInfoNode()
        if let gameInfoNode = gameInfoNode {
            addChild(gameInfoNode)
        }
    }
    
    private func updateProgress() {
        if let progressViewNode = progressViewNode {
            let size = progressViewNode.size
            
            let padding: CGFloat = size.width * 0.1
            let width = size.width - 2 * padding
            let height: CGFloat = size.height * 0.1
            let top = 0.5 * (size.height - height)
            let radius: CGFloat = 0.2 * height
            
            let progressFrame = CGRect(x: padding, y: top, width: width, height: height)
            let center = CGPoint(x: -0.5 * size.width, y: -0.5 * size.height)
            
            bgProgressNode?.path = CGPath.init(roundedRect: progressFrame, cornerWidth: radius, cornerHeight: radius, transform: nil)
            bgProgressNode?.strokeColor = .lightGray
            bgProgressNode?.fillColor = .lightGray
            bgProgressNode?.position = center
            
            //progress
            let progressPadding: CGFloat = 2
            let maxProgressWidth = progressFrame.width - 2 * progressPadding
            let progressValueLeft = progressFrame.minX + progressPadding
            let progressValueTop = progressFrame.minY + progressPadding
            let progressValueHeight = progressFrame.height - 2 * progressPadding
            let progressValueWidth = progress * maxProgressWidth
            
            let progressValueFrame = CGRect(x: progressValueLeft, y: progressValueTop, width: progressValueWidth, height: progressValueHeight)
            progressNode?.path = CGPath.init(roundedRect: progressValueFrame, cornerWidth: radius, cornerHeight: radius, transform: nil)
            progressNode?.strokeColor = .green
            progressNode?.fillColor = .green
            //progressNode?.position = CGPoint(x: center.x - 0.5 * (progressValueWidth - maxProgressWidth), y: center.y)
            progressNode?.position = CGPoint(x: center.x , y: center.y)
        }
    }
    
    func layout2DOverlay(newSize: CGSize) {
        if let progressViewNode = progressViewNode {
            let center = CGPoint(x: 0.5 * newSize.width, y: 0.5 * newSize.height)
            let progressViewWidth = 0.3 * newSize.width
            let progressViewHeight = 0.5 * progressViewWidth
            let progressViewSize = CGSize(width: progressViewWidth, height: progressViewHeight)
            progressViewNode.size = progressViewSize
            progressViewNode.position = center
            updateProgress()
        }
        
        if let gameInfoNode = gameInfoNode {
            gameInfoNode.setSuperSize(newSize)
        }
        

        
//        if let spriteNode = spriteNode {
//            spriteNode.size = CGSize(width: 50, height: 50)
//            let top = newSize.height - spriteNode.size.height - 0
//            let left = newSize.width - spriteNode.size.width - 0
//            spriteNode.position = CGPoint(x: left, y: top)
//        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if let gameInfoNode = gameInfoNode {
            let gameInfoNodeLocation = event.location(in: gameInfoNode)
            if gameInfoNode.isHelp(point: gameInfoNodeLocation) {
                isHelpAction?()
            }
        }
    }
}

extension OverlayScene {
    func progressViewHidden(_ hidden: Bool) {
        progressViewNode?.isHidden = hidden
    }
    
    func progressViewSetProgress(_ progress: CGFloat) {
        self.progress = progress
        updateProgress()
    }
    
    func setValue(doubleCount: Int, itemCount: Int) {
        gameInfoNode?.setValue(doubleCount: doubleCount, itemCount: itemCount)
    }
}

class GameInfoNode: SKSpriteNode {
    private let proportion: CGFloat = 3
    private let scale: CGFloat = 0.15
    private var countImageNode: SKSpriteNode?
    private var freeDoubleImageNode: SKSpriteNode?
    private var helpImageNode: SKSpriteNode?
    private var countValueNode: SKLabelNode?
    private var countFreeDoubleValueNode: SKLabelNode?
    
    required init() {
        super.init(texture: nil, color: .white, size: .zero)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }
    
    private func initView() {
        countImageNode = SKSpriteNode(imageNamed: "mahjong")
        if let countImageNode = countImageNode {
            addChild(countImageNode)
        }
        
        freeDoubleImageNode = SKSpriteNode(imageNamed: "mahjong_double")
        if let freeDoubleImageNode = freeDoubleImageNode {
            addChild(freeDoubleImageNode)
        }
        
        helpImageNode = SKSpriteNode(imageNamed: "help_blue")
        if let helpImageNode = helpImageNode {
            addChild(helpImageNode)
        }
        
        countValueNode = SKLabelNode(fontNamed: "Arial")
        countValueNode?.text = "0"
        countValueNode?.fontColor = .black
        countValueNode?.verticalAlignmentMode = .center
        countValueNode?.horizontalAlignmentMode = .center
        countValueNode?.fontSize = 29.0
        countValueNode?.zPosition = 1
        if let countValueNode = countValueNode {
            addChild(countValueNode)
        }
        
        countFreeDoubleValueNode = SKLabelNode(fontNamed: "Arial")
        countFreeDoubleValueNode?.text = "0"
        countFreeDoubleValueNode?.fontColor = .black
        countFreeDoubleValueNode?.verticalAlignmentMode = .center
        countFreeDoubleValueNode?.horizontalAlignmentMode = .center
        countFreeDoubleValueNode?.fontSize = 29.0
        countFreeDoubleValueNode?.zPosition = 1
        if let countFreeDoubleValueNode = countFreeDoubleValueNode {
            addChild(countFreeDoubleValueNode)
        }
        
    }
    
    func setSuperSize(_ superSize: CGSize) {
        let mainWidth = superSize.width * scale
        let mainHeight = mainWidth / proportion
        self.size = CGSize(width: mainWidth, height: mainHeight)
        self.position = CGPoint(x: superSize.width - 0.5 * mainWidth, y: superSize.height - 0.5 * mainHeight)
        
        let itemStep: CGFloat = mainWidth / 3
        let itemSize = CGSize(width: itemStep * 0.4, height: itemStep * 0.4)
        let itemCentrY = itemSize.height * 0.5 + 2
        
        if let countImageNode = countImageNode, let freeDoubleImageNode = freeDoubleImageNode, let helpImageNode = helpImageNode {
            countImageNode.size = itemSize
            freeDoubleImageNode.size = itemSize
            helpImageNode.size = itemSize
            
            countImageNode.position = CGPoint(x: -itemStep, y: itemCentrY)
            freeDoubleImageNode.position = CGPoint(x: 0, y: itemCentrY)
            helpImageNode.position = CGPoint(x: itemStep, y: itemCentrY)
        }
        
        let valueSize = CGSize(width: itemStep, height: itemStep * 0.4)
        if let countValueNode = countValueNode, let countFreeDoubleValueNode = countFreeDoubleValueNode {
            countValueNode.fontSize = valueSize.height
            countFreeDoubleValueNode.fontSize = valueSize.height
            
            countValueNode.position = CGPoint(x: -itemStep, y: -itemCentrY)
            countFreeDoubleValueNode.position = CGPoint(x: 0, y: -itemCentrY)
        }
    }
    
    func setValue(doubleCount: Int, itemCount: Int) {
        countValueNode?.text = "\(itemCount)"
        countFreeDoubleValueNode?.text = "\(doubleCount)"
    }
    
    func isHelp(point: CGPoint) -> Bool {
        return helpImageNode?.contains(point) ?? false
    }
}
