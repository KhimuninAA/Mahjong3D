//
//  OverlayScene.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 21.07.2023.
//

import Foundation
import Cocoa
import SceneKit
import SpriteKit

enum OverlayType {
    case none
    case progress(value: CGFloat)
    case game(doubleCount: Int, itemCount: Int)
    case youWin(levalName: String, stepCount: Int)
    case youLose(levalName: String, itemCount: Int)
}

class OverlayScene: SKScene {
    private var progressNode: ProgressNode?
    private var gameInfoNode: GameInfoNode?
    private var youLoseNode: YouLoseNode?
    private var youWinNode: YouWinNode?
    
    var isHelpAction: (() -> Void)?
    var isNewAction: (() -> Void)?
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {
            // ignore
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        initScene()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initScene()
    }

    private func initScene(){
        scaleMode = .resizeFill
        
        //Progress
        progressNode = ProgressNode()
        if let progressNode = progressNode {
            addChild(progressNode)
        }
        
        //info
        gameInfoNode = GameInfoNode()
        if let gameInfoNode = gameInfoNode {
            addChild(gameInfoNode)
        }

        //You Lose
        youLoseNode = YouLoseNode()
        youLoseNode?.isHidden = true
        if let youLoseNode = youLoseNode {
            addChild(youLoseNode)
        }

        //You Win
        youWinNode = YouWinNode()
        youWinNode?.isHidden = true
        if let youWinNode = youWinNode {
            addChild(youWinNode)
        }
    }
    
    func layout2DOverlay(newSize: CGSize) {
        progressNode?.setSuperSize(newSize)
        gameInfoNode?.setSuperSize(newSize)
        youLoseNode?.setSuperSize(newSize)
        youWinNode?.setSuperSize(newSize)
    }
    
    override func mouseDown(with event: NSEvent) {
        if let gameInfoNode = gameInfoNode, gameInfoNode.isHidden == false {
            //Help
            let gameInfoNodeLocation = event.location(in: gameInfoNode)
            if gameInfoNode.isHelp(point: gameInfoNodeLocation) {
                isHelpAction?()
            }
        }
        if let youLoseNode = youLoseNode, youLoseNode.isHidden == false {
            //New
            let youLoseNodeLocation = event.location(in: youLoseNode)
            if youLoseNode.isNew(point: youLoseNodeLocation) {
                isNewAction?()
            }
        }
        if let youWinNode = youWinNode, youWinNode.isHidden == false {
            //New
            let youWinNodeLocation = event.location(in: youWinNode)
            if youWinNode.isNew(point: youWinNodeLocation) {
                isNewAction?()
            }
        }
    }
}

extension OverlayScene {
    private func hidden(by type: OverlayType) {
        var isProgressHidden = true
        var isGameInfoHidden = true
        var isYouWinHidden = true
        var isYouLoseHidden = true
        switch type {
        case .none:
            break
        case .progress(value: _):
            isProgressHidden = false
        case .game(doubleCount: _, itemCount: _):
            isGameInfoHidden = false
        case .youWin:
            isYouWinHidden = false
        case .youLose:
            isYouLoseHidden = false
        }
        progressNode?.isHidden = isProgressHidden
        gameInfoNode?.isHidden = isGameInfoHidden
        youLoseNode?.isHidden = isYouLoseHidden
        youWinNode?.isHidden = isYouWinHidden
    }

    func set(type: OverlayType) {
        hidden(by: type)
        switch type {
        case .none:
            break
        case .progress(value: let progress):
            progressNode?.setProgress(progress)
        case .game(doubleCount: let doubleCount, itemCount: let itemCount):
            gameInfoNode?.setValue(doubleCount: doubleCount, itemCount: itemCount)
        case .youWin(levalName: let levalName, stepCount: let stepCount):
            youWinNode?.setLevalName(levalName)
            youWinNode?.setStepCount(stepCount)
        case .youLose(levalName: let levalName, itemCount: let itemCount):
            youLoseNode?.setLevalName(levalName)
            youLoseNode?.setItemCount(itemCount)
        }
    }
}
