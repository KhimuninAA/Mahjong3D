//
//  YouWinNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 28.07.2023.
//

import Foundation
import SpriteKit

class YouWinNode: SKSpriteNode {

    required init() {
        super.init(texture: nil, color: .green, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
    }

    func setSuperSize(_ superSize: CGSize) {
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
