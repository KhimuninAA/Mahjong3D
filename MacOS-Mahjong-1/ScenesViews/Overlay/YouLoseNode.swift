//
//  YouLoseNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 26.07.2023.
//

import Foundation
import SpriteKit

class YouLoseNode: SKSpriteNode {

    required init() {
        let texture = SKTexture(imageNamed: "YouWin")
        super.init(texture: texture, color: .clear, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
    }

    func setSuperSize(_ superSize: CGSize) {
        //2197
        //2477
        let center = CGPoint(x: 0.5 * superSize.width, y: 0.5 * superSize.height)
        let progressViewWidth = 0.3 * superSize.width
        let progressViewHeight = 0.5 * progressViewWidth
        let progressViewSize = CGSize(width: progressViewWidth, height: progressViewHeight)
        self.size = progressViewSize
        self.position = center
    }

    func isNew(point: CGPoint) -> Bool {
        //return helpImageNode?.contains(point) ?? false
        return false
    }
}
