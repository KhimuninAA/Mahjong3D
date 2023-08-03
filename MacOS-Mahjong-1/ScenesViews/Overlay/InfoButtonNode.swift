//
//  InfoButtonNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 03.08.2023.
//

import Foundation
import SpriteKit

enum InfoButtonType {
    case info
    case help

    func asString() -> String {
        var str: String = ""

        switch self {
        case .info:
            str = "i"
        case .help:
            str = "?"
        }

        return str
    }
}

class InfoButtonNode: SKSpriteNode {
    private var labelNode: SKLabelNode = SKLabelNode(fontNamed: "Arial")

    required init() {
        let texture = SKTexture(imageNamed: "InfoBtn")
        super.init(texture: texture, color: .clear, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        labelNode.text = ""
        labelNode.fontColor = .white
        labelNode.verticalAlignmentMode = .center
        labelNode.horizontalAlignmentMode = .center
        labelNode.fontSize = 0.0
        labelNode.zPosition = 1
        addChild(labelNode)
    }
}

extension InfoButtonNode {
    func infoSize() -> CGSize? {
        return texture?.size()
    }

    func updateUI() {
        labelNode.fontSize = 0.7 * self.size.height
        labelNode.position = CGPoint(x: 0, y: 0)
    }

    func setType(_ type: InfoButtonType) {
        labelNode.text = type.asString()
    }
}
