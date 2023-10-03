//
//  LevelImageCashe.swift
//  Mahjong
//
//  Created by Алексей Химунин on 03.10.2023.
//

import Foundation
import AppKit

class LevelImageCashe {
    
    static func updateImageCashe(levelsData: LevelsData?, onComplition: (() -> Void)?) {
        DispatchQueue.global(qos: .userInitiated).async { //unspecified userInitiated
            var loadCount: Int = 0
            var scene: SceneView?
            if let levelsData = levelsData {
                for level in levelsData.levels {
                    if getImage(by: level.name) == nil {
                        if scene == nil {
                            scene = SceneView(frame: CGRect(x: 0, y: 0, width: 300, height: 250), options: nil)
                        }
                        scene?.newGame(levelItem: level, isProgress: false)
                        if let img = scene?.imageRepresentation() {
                            loadCount += 1
                            saveImage(img, name: level.name)
                        }
                    }
                }
            }
            scene = nil
            if loadCount > 0 {
                DispatchQueue.main.async {
                    onComplition?()
                }
            }
        }
    }

    static func getPath(name: String) -> URL? {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            if #available(macOS 13.0, *) {
                return url.appending(path: "\(name).png")
            } else {
                return url.appendingPathComponent("\(name).png")
            }
        } else {
            return nil
        }
    }

    static func saveImage(_ image: NSImage, name: String) {
        guard let url = getPath(name: name),
              let data = image.tiffRepresentation,
              let rep = NSBitmapImageRep(data: data),
              let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
            return
        }

        do {
            try imgData.write(to: url)
        }catch{
        }
    }

    static func getImage(by name: String) -> NSImage? {
        if let url = getPath(name: name) {
            let image = NSImage.init(contentsOf: url)
            return image
        }
        return nil
    }

    static func getImageForMenu(by name: String) -> NSImage? {
        if let image = getImage(by: name) {
            let rH: CGFloat = 44
            let rW = image.size.width * (rH / image.size.height)
            var destSize = NSMakeSize(CGFloat(rW), CGFloat(rH))
            var newImage = NSImage(size: destSize)
            newImage.lockFocus()
            image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: .sourceOver, fraction: CGFloat(1))
            newImage.unlockFocus()
            newImage.size = destSize
            if let data = newImage.tiffRepresentation {
                return NSImage(data: data)
            }
        }
        return nil
    }
}
