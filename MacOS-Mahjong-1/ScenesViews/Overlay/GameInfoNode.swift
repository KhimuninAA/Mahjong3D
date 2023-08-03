//
//  GameInfoNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 26.07.2023.
//

import Foundation
import SpriteKit

class GameInfoNode: SKSpriteNode {
    private let infoScale: CGFloat = 1000 //0.4 //0.6 //0.3
    private var countValueNode1 = InfoValueNode()
    private var countFreeDoubleValueNode1 = InfoValueNode()
    private var helpButtonNode = InfoButtonNode()

    required init() {
        super.init(texture: nil, color: .clear, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        countValueNode1.set(image: .count)
        addChild(countValueNode1)
        countFreeDoubleValueNode1.set(image: .double)
        addChild(countFreeDoubleValueNode1)
        helpButtonNode.setType(.help)
        addChild(helpButtonNode)
    }

    func setSuperSize(_ superSize: CGSize) {
        self.size = CGSize(width: 0, height: 0)
        self.position = CGPoint(x: superSize.width, y: superSize.height)
        
        let scale = superSize.height / infoScale

        if let infoSize = countValueNode1.infoSize() {
            countValueNode1.size = CGSize(width: infoSize.width * scale, height: infoSize.height * scale)
        }
        countValueNode1.updateUI()

        if let infoSize = countFreeDoubleValueNode1.infoSize() {
            countFreeDoubleValueNode1.size = CGSize(width: infoSize.width * scale, height: infoSize.height * scale)
        }
        countFreeDoubleValueNode1.updateUI()

        if let infoSize = helpButtonNode.infoSize() {
            helpButtonNode.size = CGSize(width: infoSize.width * scale, height: infoSize.height * scale)
        }
        helpButtonNode.updateUI()

        let nodeSpase = 0.3 * helpButtonNode.size.height
        let infoY = -(0.5 * helpButtonNode.size.height + nodeSpase)
        var left = -(0.5 * helpButtonNode.size.width + nodeSpase)
        helpButtonNode.position = CGPoint(x: left, y: infoY)
        left += -0.5 * helpButtonNode.size.width - 0.5 * countFreeDoubleValueNode1.size.width - nodeSpase
        countFreeDoubleValueNode1.position = CGPoint(x: left, y: infoY)
        left += -nodeSpase - 0.5 * countFreeDoubleValueNode1.size.width - 0.5 * countValueNode1.size.width
        countValueNode1.position = CGPoint(x: left, y: infoY)
    }

    func setValue(doubleCount: Int, itemCount: Int) {
        countFreeDoubleValueNode1.setValue(doubleCount)
        countValueNode1.setValue(itemCount)
    }

    func isHelp(point: CGPoint) -> Bool {
        return helpButtonNode.contains(point)
    }
}
