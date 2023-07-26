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
        super.init(texture: nil, color: .white, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
    }

    func setSuperSize(_ superSize: CGSize) {
    }

    func isNew(point: CGPoint) -> Bool {
        //return helpImageNode?.contains(point) ?? false
        return false
    }
}
