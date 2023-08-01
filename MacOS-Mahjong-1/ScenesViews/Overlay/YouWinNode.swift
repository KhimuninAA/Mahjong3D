//
//  YouWinNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 28.07.2023.
//

import Foundation
import SpriteKit

class YouWinNode: SKSpriteNode {
    private var okButtonNode: SKSpriteNode?
    private var levelTitleLabelNode: SKLabelNode?
    private var totalTitleLabelNode: SKLabelNode?
    private var totalLabelNode: SKLabelNode?

    required init() {
        let texture = SKTexture(imageNamed: "YouWin2")
        super.init(texture: texture, color: .clear, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        okButtonNode = SKSpriteNode(imageNamed: "OK")
        if let okButtonNode = okButtonNode {
            addChild(okButtonNode)
        }

        levelTitleLabelNode = SKLabelNode(fontNamed: "Avenir")
        levelTitleLabelNode?.fontColor = NSColor(hex: "5E4059")
        levelTitleLabelNode?.verticalAlignmentMode = .center
        levelTitleLabelNode?.horizontalAlignmentMode = .center
        levelTitleLabelNode?.fontSize = 29.0
        levelTitleLabelNode?.zPosition = 1
        if let levelTitleLabelNode = levelTitleLabelNode {
            addChild(levelTitleLabelNode)
        }

        totalTitleLabelNode = SKLabelNode(fontNamed: "Avenir")
        totalTitleLabelNode?.text = NSLocalizedString("Сделано ходов:", comment: "")
        totalTitleLabelNode?.fontColor = NSColor(hex: "5E4059")
        totalTitleLabelNode?.verticalAlignmentMode = .center
        totalTitleLabelNode?.horizontalAlignmentMode = .center
        totalTitleLabelNode?.fontSize = 29.0
        totalTitleLabelNode?.zPosition = 1
        if let totalTitleLabelNode = totalTitleLabelNode {
            addChild(totalTitleLabelNode)
        }

        totalLabelNode = SKLabelNode(fontNamed: "Avenir")
        totalLabelNode?.text = "0"
        totalLabelNode?.fontColor = .black
        totalLabelNode?.verticalAlignmentMode = .center
        totalLabelNode?.horizontalAlignmentMode = .center
        totalLabelNode?.fontSize = 29.0
        totalLabelNode?.zPosition = 1
        if let totalLabelNode = totalLabelNode {
            addChild(totalLabelNode)
        }
    }

    func setLevalName(_ levalName: String) {
        levelTitleLabelNode?.text = levalName
    }

    func setStepCount(_ stepCount: Int) {
        totalLabelNode?.text = "\(stepCount)"
    }

    func setSuperSize(_ superSize: CGSize) {
        let prop: CGFloat
        if let texture = self.texture {
            prop = texture.size().width/texture.size().height
        } else {
            prop = 2197/2477
        }

        let scale: CGFloat = 0.6
        let center = CGPoint(x: 0.5 * superSize.width, y: 0.5 * superSize.height)
        let viewWidth = scale * superSize.width
        let viewHeight = prop * viewWidth
        let viewSize = CGSize(width: viewWidth, height: viewHeight)
        self.size = viewSize
        self.position = center

        //
        if let okButtonNode = okButtonNode {
            let okBthScale: CGFloat = 0.2
            let okBthWidth = viewWidth * okBthScale
            let okBthHeight = okBthWidth * (okButtonNode.size.height/okButtonNode.size.width)
            okButtonNode.size = CGSize(width: okBthWidth, height: okBthHeight)
            okButtonNode.position = CGPoint(x: 0, y: -0.5 * viewSize.height + okBthHeight + 0.25 * okBthHeight)
        }

        if let totalLabelNode = totalLabelNode {
            totalLabelNode.fontSize = 0.09 * viewHeight
            totalLabelNode.position = CGPoint(x: 0, y: -0.08 * viewHeight - totalLabelNode.fontSize)
        }

        if let totalTitleLabelNode = totalTitleLabelNode {
            totalTitleLabelNode.fontSize = 0.05 * viewHeight
            totalTitleLabelNode.position = CGPoint(x: 0, y: -totalTitleLabelNode.fontSize)
        }

        if let levelTitleLabelNode = levelTitleLabelNode {
            levelTitleLabelNode.fontSize = 0.05 * viewHeight
            levelTitleLabelNode.position = CGPoint(x: 0, y: 0.5 * levelTitleLabelNode.fontSize)
        }
    }

    func isNew(point: CGPoint) -> Bool {
        return okButtonNode?.contains(point) ?? false
    }

}
