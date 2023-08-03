//
//  InfoValueNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 03.08.2023.
//

import Foundation
import SpriteKit

enum InfoValueImage {
    case count
    case double

    func name() -> String {
        var name: String = ""

        switch self {
        case .count:
            name = "CountItem2"
        case .double:
            name = "DoubleItem"
        }

        return name
    }
}

class InfoValueNode: SKSpriteNode {
    private var valueNode: SKLabelNode = SKLabelNode(fontNamed: "Arial")
    private var iconNode: SKSpriteNode = SKSpriteNode()

    required init() {
        let texture = SKTexture(imageNamed: "InfoValue")
        super.init(texture: texture, color: .clear, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        valueNode.text = "0"
        valueNode.fontColor = .white
        valueNode.verticalAlignmentMode = .center
        valueNode.horizontalAlignmentMode = .center
        valueNode.fontSize = 0.0
        valueNode.zPosition = 1
        addChild(valueNode)

        //iconNode.texture = SKTexture(imageNamed: "mahjong_double")
        iconNode.color = .clear
        addChild(iconNode)
    }

}

extension InfoValueNode {
    func infoSize() -> CGSize? {
        return texture?.size()
    }

    func updateUI() {
        valueNode.fontSize = 0.7 * self.size.height
        let valueX = 0.2 * (0.5 * self.size.width)
        valueNode.position = CGPoint(x: -valueX, y: 0)

        iconNode.size = CGSize(width: self.size.height, height: self.size.height)
        let iconX = 0.5 * self.size.width - 0.5 * iconNode.size.width - 0.2 * self.size.height
        iconNode.position = CGPoint(x: iconX, y: 0)
    }

    func setValue(_ value: Int) {
        valueNode.text = "\(value)"
    }

    func set(image: InfoValueImage) {
        iconNode.texture = SKTexture(imageNamed: image.name())
    }
}
