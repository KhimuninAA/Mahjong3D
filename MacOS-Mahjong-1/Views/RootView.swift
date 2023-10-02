//
//  RootView.swift
//  MacOS-ColorLines
//
//  Created by Алексей Химунин on 05.01.2023.
//

import Foundation
import AppKit
import SceneKit

class RootView: NSView{
    var scene :SceneView?
    private var  levelsView: LevelsScrollView?

    var onUpdateLevelsAction: (() -> Void)?
    var onResizeAction: (() -> Void)?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView() {
        wantsLayer = true
        scene = SceneView(frame: .zero, options: nil)
        if let scene = scene {
            addSubview(scene)
            let levelItem = scene.getLevelData().currentLevel()
            scene.newGame(levelItem: levelItem)
        }
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        let selfSize = frame.size
        
        scene?.frame = CGRect(x: 0, y: 0, width: selfSize.width, height: selfSize.height)
        scene?.resizeView()

        levelsView?.frame = CGRect(x: 0, y: 0, width: selfSize.width, height: selfSize.height)
        onResizeAction?()
    }
    
    func newGame() {
        if let levelData = scene?.getLevelData() {
            scene?.newGame(levelItem: levelData.currentLevel())
        }
    }

    func levelsViewClear() {
        levelsView?.removeFromSuperview()
        levelsView = nil
    }

    func showLevels() {
        if levelsView == nil {
            levelsView = LevelsScrollView(frame: .zero)
            if let levelsView = levelsView {
                let levelData = scene?.getLevelData()
                levelsView.levelsView.setLevelsData(levelData)
                let selfSize = frame.size
                levelsView.frame = CGRect(x: 0, y: 0, width: selfSize.width, height: selfSize.height)
                addSubview(levelsView)
                levelsView.levelsView.onLevelIndexAction = { [weak self] (index) in
                    self?.levelsViewClear()
                    DispatchQueue.main.async {
                        self?.scene?.setLevelIndex(index)
                        self?.onUpdateLevelsAction?()
                    }
                }
            }
        } else {
            levelsViewClear()
        }
    }
}
