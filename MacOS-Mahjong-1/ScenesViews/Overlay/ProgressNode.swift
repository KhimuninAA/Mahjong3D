//
//  ProgressNode.swift
//  Mahjong
//
//  Created by Алексей Химунин on 26.07.2023.
//

import Foundation
import SpriteKit

class ProgressNode: SKSpriteNode {
    private var progress: CGFloat = 0
    private var bgProgressNode: SKShapeNode?
    private var progressNode: SKShapeNode?
    
    required init() {
        super.init(texture: nil, color: .gray, size: .zero)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        bgProgressNode = SKShapeNode()
        if let bgProgressNode = bgProgressNode {
            self.addChild(bgProgressNode)
        }
        progressNode = SKShapeNode()
        if let progressNode = progressNode {
            self.addChild(progressNode)
        }
    }

    func setProgress(_ progress: CGFloat) {
        self.progress = progress
        updateProgress()
    }

    private func updateProgress() {
        let size = self.size

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

    func setSuperSize(_ superSize: CGSize) {
        let center = CGPoint(x: 0.5 * superSize.width, y: 0.5 * superSize.height)
        let progressViewWidth = 0.3 * superSize.width
        let progressViewHeight = 0.5 * progressViewWidth
        let progressViewSize = CGSize(width: progressViewWidth, height: progressViewHeight)
        self.size = progressViewSize
        self.position = center
        updateProgress()
    }
}
