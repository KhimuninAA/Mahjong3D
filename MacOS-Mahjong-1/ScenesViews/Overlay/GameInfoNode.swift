//
//  GameInfoNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 26.07.2023.
//

import Foundation
import SpriteKit

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
