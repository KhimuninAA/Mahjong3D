//
//  ItemNone.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 20.07.2023.
//

import Foundation
import SceneKit

class ItemNone: SCNNode {
    private static var itemIndex: Int = 0
    var particleSystem: SCNParticleSystem?
    var pos: Pos = Pos(x: 0, y: 0, z: 0)
    var type: ItemType

    init(geometry: SCNGeometry?, type: ItemType) {
        self.type = type
        super.init()
        ItemNone.itemIndex += 1
        self.name = "\(ItemNone.itemIndex)"
        self.geometry = geometry
    }
    /* Xcode required this */
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static var size: SCNVector3 {
        return SCNVector3(x: 0.6, y: 0.4, z: 0.8)
    }
    static let selectHeight: CGFloat = 0.5
    static let paddingLeft: CGFloat = -4
    static let paddingTop: CGFloat = -3
}

extension ItemNone {
    func remove() {
        self.removeAllParticleSystems()
        if self.parent != nil {
            self.removeFromParentNode()
        }
        cleanup()
    }
    
    func showHelp() {
        let helpParticleSystem = SCNParticleSystem()
        helpParticleSystem.emitterShape = self.geometry
        
        helpParticleSystem.birthLocation = .surface

        helpParticleSystem.birthRate = 3000
        helpParticleSystem.particleLifeSpan = 0.4
        helpParticleSystem.particleSize = 0.05
        helpParticleSystem.particleImage = NSImage(named: "env_star")
        helpParticleSystem.particleColor = .green
        //helpParticleSystem.speedFactor = 2
        self.addParticleSystem(helpParticleSystem)
        
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false, block: { [weak self] _ in
            self?.removeParticleSystem(helpParticleSystem)
        })
    }
    
    func createParticleSystem() {
        particleSystem = SCNParticleSystem()

        let height = ItemNone.size.y - (ItemNone.size.y * 0.1)
        let geometry = SCNBox(width: ItemNone.size.x, height: height, length: ItemNone.size.z, chamferRadius: 0.05)
        particleSystem?.emitterShape = geometry
        
        particleSystem?.birthLocation = .surface

        particleSystem?.birthRate = 3000
        particleSystem?.particleLifeSpan = 0.3
        particleSystem?.particleSize = 0.03
        particleSystem?.particleImage = NSImage(named: "env_star")

//        particleSystem?.birthDirection = .surfaceNormal
//        particleSystem?.isAffectedByGravity = true
//        particleSystem?.isLightingEnabled = false
//        particleSystem?.loops = true
//        particleSystem?.sortingMode = .none
//        particleSystem?.isBlackPassEnabled = true
//        particleSystem?.blendMode = .additive
//
//        particleSystem?.particleColor = NSColor.green

        if let particleSystem = particleSystem {
            self.addParticleSystem(particleSystem)
        }
    }

    func removeParticleSystem() {
        if let particleSystem = particleSystem {
            self.removeParticleSystem(particleSystem)
            self.particleSystem = nil
        }
    }

    func setSelected(_ selected: Bool) {
        if selected {
            self.createParticleSystem()
        }
        let toVector = selected ? selectVector3() : defaultVector3()
        let animation = SCNAction.move(to: toVector, duration: 0.4)
        self.runAction(animation, completionHandler: { [weak self] in
            if !selected {
                self?.removeParticleSystem()
            }
        })
    }

    func defaultVector3() -> SCNVector3{
        return SCNVector3Make(CGFloat(pos.x - 1) * ItemNone.size.x + ItemNone.paddingLeft, CGFloat(pos.z - 1) * ItemNone.size.y + ItemNone.size.y * 0.5, CGFloat(pos.y - 1) * ItemNone.size.z + ItemNone.paddingTop)
    }

    func selectVector3() -> SCNVector3{
        return SCNVector3Make(CGFloat(pos.x - 1) * ItemNone.size.x + ItemNone.paddingLeft, CGFloat(pos.z - 1) * ItemNone.size.y + ItemNone.selectHeight + ItemNone.size.y * 0.5, CGFloat(pos.y - 1) * ItemNone.size.z + ItemNone.paddingTop)
    }

    static func scale(topImage: NSImage, scale: CGFloat) -> NSImage {
        let size = CGSize(width: 1024, height: 1024) //1024 //bottomImage.size //CGSize(width: 300, height: 300)

        let y = 0.5 * (size.height - (size.height/scale))
        let x = 0.5 * (size.width - (size.width/scale)) * 0.8

        let image = NSImage()
        image.lockFocus()
        //draw your stuff here

        image.draw(in: CGRect(origin: .zero, size: size))
        // x:140
        let frame2 = CGRect(x: x, y: y, width: size.width/scale, height: size.height/scale)
        image.draw(in: frame2)

        image.unlockFocus()
        return image
    }

    static func merge(bottomImage: NSImage, topImage: NSImage) -> NSImage {
        let image = bottomImage.copy() as! NSImage
        let size = image.size //CGSize(width: 1024, height: 1024) //1024 //bottomImage.size //CGSize(width: 300, height: 300)

        let scale: CGFloat = 1.3
        let y: CGFloat = 0.5 * (size.height - (size.height/scale))
        let x: CGFloat = (0.5 * (size.width - (size.width/scale)))

        image.lockFocus()
        //draw your stuff here

        image.draw(in: CGRect(origin: .zero, size: size))
        // x:140
        let frame2 = CGRect(x: x, y: y, width: size.width/scale, height: size.height/scale)
        topImage.draw(in: frame2)

        image.unlockFocus()
        return image
    }

    static func getMaterial(mergeImage: NSImage?) -> SCNMaterial {
        let itemMaterial = SCNMaterial.init()
        itemMaterial.locksAmbientWithDiffuse = true
        itemMaterial.diffuse.contents = nil
        itemMaterial.lightingModel = .physicallyBased
        itemMaterial.isDoubleSided = false
        itemMaterial.normal.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_normal")
        itemMaterial.metalness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_metallic")
        itemMaterial.roughness.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_roughness")
        itemMaterial.ambientOcclusion.contents = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
        //diffuse
        // Front TexturesCom_Metal_SteelRough2_1K_ao
        let diffuseImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
        if let mergeImage = mergeImage, let diffuseImage = diffuseImage {
            let newImage = merge(bottomImage: diffuseImage, topImage: mergeImage)
            itemMaterial.diffuse.contents = newImage
        } else {
            itemMaterial.diffuse.contents = diffuseImage
        }

        return itemMaterial
    }

    static func make(baseMaterial: SCNMaterial, material: SCNMaterial?, type: ItemType) -> ItemNone {
        let itemGeometry: SCNGeometry? = SCNBox(width: ItemNone.size.x, height: ItemNone.size.y, length: ItemNone.size.z, chamferRadius: 0.05)
        let itemNode = ItemNone(geometry: itemGeometry, type: type)

        let itemMaterial = material ?? baseMaterial
        itemNode.geometry?.materials = [baseMaterial, baseMaterial, baseMaterial, baseMaterial, itemMaterial, baseMaterial]

        return itemNode
    }
}

extension NSImage {
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            print(error)
            return false
        }
    }
}

extension SCNMaterial {
    func updateType(_ type: ItemType) -> SCNMaterial{
        let newMat = self.copy() as! SCNMaterial
        if let image = NSImage(named: type.imageName) {
            newMat.diffuse.contents = image
        }
        return newMat
    }
}

extension SCNNode {
    func cleanup() {
        for child in childNodes {
            child.cleanup()
        }
        geometry = nil
    }
}
