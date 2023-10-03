//
//  LevelsView.swift
//  Mahjong
//
//  Created by Алексей Химунин on 02.10.2023.
//

import Foundation
import AppKit

class LevelsScrollView: NSScrollView {
    var levelsView: LevelsView = LevelsView(frame: .zero)

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        documentView = levelsView
    }
}

class LevelsViewFlowLayout: NSCollectionViewFlowLayout {
    override init() {
        super.init()
        minimumLineSpacing = 4
        minimumInteritemSpacing = 4
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class LevelsView: NSCollectionView{
    private var levelsViewFlowLayout: LevelsViewFlowLayout = LevelsViewFlowLayout()
    private var levelsData: LevelsData?

    var onLevelIndexAction: ((_ index: Int, _ rect: CGRect) -> Void)?
    var onUpdateLevelsAction: (() -> Void)?

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    func setLevelsData(_ levelsData: LevelsData?) {
        self.levelsData = levelsData
        reloadData()
        LevelImageCashe.updateImageCashe(levelsData: levelsData, onComplition: { [weak self] in
            self?.reloadData()
            self?.onUpdateLevelsAction?()
        })
    }

    private func initView() {
        self.backgroundColors = [.white]
        self.collectionViewLayout = levelsViewFlowLayout
        self.dataSource = self
        //self.delegate = self
        register(
            LevelViewItem.self,
          forItemWithIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LevelViewItem")
        )
        self.allowsMultipleSelection = false
        self.isSelectable = true
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        calcCellSize()
    }

    private func calcCellSize() {
        let selfSize = self.bounds.size
        let padding: CGFloat = CGFloat(Int(selfSize.width * 0.05))
        let numberInRow: CGFloat = 2

        levelsViewFlowLayout.minimumLineSpacing = padding
        levelsViewFlowLayout.minimumInteritemSpacing = padding
        levelsViewFlowLayout.sectionInset = NSEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)

        let itemWidth = (selfSize.width - (numberInRow + 1) * padding) / numberInRow
        levelsViewFlowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 0.8)
    }

    func getLevelItem(by index: Int) -> LevelItem? {
        if let levelsData = levelsData {
            if levelsData.levels.count >= 0 && levelsData.levels.count > index {
                return levelsData.levels[index]
            }
        }
        return nil
    }
}

extension LevelsView: NSCollectionViewDataSource {
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        calcCellSize()
        if let levelsData = levelsData {
            return levelsData.levels.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let cell = collectionView.makeItem(
          withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "LevelViewItem"),
          for: indexPath
        ) as! LevelViewItem

        if let levelItem = getLevelItem(by: indexPath.item) {
            cell.setLevelItem(levelItem)
        }

        return cell
    }
}

extension LevelsView: NSCollectionViewDelegate {
    func collectionView(_ collectionView: NSCollectionView, didSelectItemsAt indexPaths: Set<IndexPath>) {
        if let indexPath = indexPaths.first {
            var rect = CGRect.zero
            if let cell = collectionView.item(at: indexPath) as? LevelViewItem {
                if let levelView = cell.view as? LevelView {
                    rect = self.convert(levelView.imageView.frame, from: levelView)
                }
            }

            onLevelIndexAction?(indexPath.item, rect)
        }
    }
}

class LevelView: NSView {
    var label: KhLabel = KhLabel()
    var imageView = NSImageView(frame: .zero)
    var progressIndicator: NSProgressIndicator = NSProgressIndicator()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initView() {
        label.stringValue = "..."
        label.alignment = .center
        addSubview(label)
        
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.wantsLayer = true
        addSubview(imageView)

        progressIndicator.isHidden = true
        progressIndicator.style = .spinning
        addSubview(progressIndicator)
    }

    func setLevelItem(_ levelItem: LevelItem) {
        label.stringValue = NSLocalizedString(levelItem.name, comment: "")
        if let image = LevelImageCashe.getImage(by: levelItem.name) {
            imageView.image = image
            progressIndicator.isHidden = true
            progressIndicator.stopAnimation(nil)
        } else {
            imageView.image = nil
            progressIndicator.isHidden = false
            progressIndicator.startAnimation(nil)
        }
    }

    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        let selfSize = self.bounds.size

        let labelHeight = CGFloat(Int(selfSize.height * 0.2))
        label.font = NSFont.systemFont(ofSize: labelHeight * 0.7)
        let labelFrame = CGRect(x: 0, y: selfSize.height - labelHeight, width: selfSize.width, height: labelHeight)
        label.frame = labelFrame
        
        
        let imageViewFrame = CGRect(x: 0, y: 0, width: selfSize.width, height: labelFrame.minY)
        imageView.frame = imageViewFrame

        progressIndicator.frame = imageViewFrame
    }
    
    func getLevelImage(by levelItem: LevelItem, itemSize: CGSize) -> NSImage? {
        let scene = SceneView(frame: CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height), options: nil)
        scene.newGame(levelItem: levelItem, isProgress: false)
        let img = scene.imageRepresentation()
        return img
    }
}

class LevelViewItem: NSCollectionViewItem {
    override func loadView() {
        self.view = LevelView()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.clear.cgColor
    }

    func setLevelItem(_ levelItem: LevelItem) {
        if let view = self.view as? LevelView {
            view.setLevelItem(levelItem)
        }
    }
    
    func setImage(_ image: NSImage?) {
        if let view = self.view as? LevelView {
            view.imageView.image = image
        }
    }
}
