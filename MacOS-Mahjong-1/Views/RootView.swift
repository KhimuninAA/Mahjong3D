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
                levelsView.levelsView.onLevelIndexAction = { [weak self] (index, rect) in
                    let newRect = self?.convert(rect, from: levelsView) ?? rect
                    self?.scene?.setLevelIndex(index, isProgress: false)
                    let img = self?.scene?.imageRepresentation()
                    DispatchQueue.main.async {
                        let view = NSImageView(frame: newRect)
                        //view.layer = CALayer()
                        //view.layer?.contentsGravity = CALayerContentsGravity.resizeAspectFill
                        //view.layer?.contents = img
                        //view.wantsLayer = true
                        view.image = img
                        view.imageScaling = .scaleProportionallyUpOrDown
                        //view.image = img
                        view.wantsLayer = true
                        view.layer?.backgroundColor = NSColor.red.cgColor
                        self?.addSubview(view)

//                        CATransaction.begin()
//                        CATransaction.setCompletionBlock({
//                            self?.levelsViewClear()
//                            view.isHidden = true
//                            view.alphaValue = 0
//                            view.removeFromSuperview()
//                            self?.levelsViewClear()
//                            self?.onUpdateLevelsAction?()
//                        })
//                        let anim = CABasicAnimation(keyPath: "transform")
//                        anim.fromValue = CATransform3DMa
//                        //CATransform3DMakeScale(1,1,1)
//                        anim.toValue = CATransform3DMakeScale(2,2,1)
//                        anim.duration = 5.00
//                        view.layer?.add(anim, forKey: "transform")
//                        CATransaction.commit()

                        NSAnimationContext.runAnimationGroup { [weak self] context in
                            context.duration = 20
                            context.allowsImplicitAnimation = true
                            if let self = self {
                                view.animator().frame = self.bounds
                                //view.frame = self.bounds
                            }
                        } completionHandler: {
                            self?.levelsViewClear()
                            view.isHidden = true
                            view.alphaValue = 0
                            view.removeFromSuperview()
                            self?.levelsViewClear()
                            self?.onUpdateLevelsAction?()
                        }
                    }
                }
                levelsView.levelsView.onUpdateLevelsAction = { [weak self] in
                    self?.onUpdateLevelsAction?()
                }
            }
        } else {
            levelsViewClear()
        }
    }
}

open class NSImageViewFill : NSImageView {

        open override var image: NSImage? {
            set {
                self.layer = CALayer()
                self.layer?.contentsGravity = CALayerContentsGravity.resizeAspectFill
                self.layer?.contents = newValue
                self.wantsLayer = true

                super.image = newValue
            }

            get {
                return super.image
            }
        }
}
