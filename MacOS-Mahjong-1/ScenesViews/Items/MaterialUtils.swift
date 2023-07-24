//
//  MaterialUtils.swift
//  Mahjong
//
//  Created by Алексей Химунин on 24.07.2023.
//

import Foundation
import SceneKit

class MaterialUtils {
    private let normalImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_normal")
    private let metalnessImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_metallic")
    private let roughnessImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_roughness")
    private let ambientOcclusionImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
    private let diffuseImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
    private let itemsImage = NSImage(named: "items")

    private var baseMaterial: SCNMaterial!

    private var materials: [SCNMaterial] = [SCNMaterial]()

    init() {
        baseMaterial = SCNMaterial.init()
        baseMaterial.locksAmbientWithDiffuse = true
        baseMaterial.diffuse.contents = nil
        baseMaterial.lightingModel = .physicallyBased
        baseMaterial.isDoubleSided = false
        baseMaterial.normal.contents = normalImage
        baseMaterial.metalness.contents = metalnessImage
        baseMaterial.roughness.contents = roughnessImage
        baseMaterial.ambientOcclusion.contents = ambientOcclusionImage
        baseMaterial.diffuse.contents = diffuseImage
    }

    private func createEmptyImage() -> NSImage {
        let image = NSImage(size: CGSize(width: 256 * 6, height: 256 * 6))
        //let image = NSImage(cgImage: CGImage(), size: CGSize(width: 256 * 6, height: 256 * 6))
        image.lockFocus()
        //draw your stuff here

        image.draw(in: CGRect(origin: .zero, size: CGSize(width: 256 * 6, height: 256 * 6)))

        image.unlockFocus()
        return image
    }

    private func merge(bottomImage: NSImage, topImage: NSImage, rect: CGRect) -> NSImage {
        let image = bottomImage.copy() as! NSImage
        let size = image.size

        image.lockFocus()
        //draw your stuff here

        image.draw(in: CGRect(origin: .zero, size: size))

        topImage.draw(in: rect)

        image.unlockFocus()
        return image
    }

    func createMaterials(onProgressAction: ((_: CGFloat) -> Void)?) {
        if materials.count > 0 {
            return
        }

        var iX: CGFloat = 0
        var iY: CGFloat = 0
        let typeCount = ItemType.allCases.count
        var imageRect = CGRect(origin: .zero, size: itemsImage?.size ?? CGSize(width: 0, height: 0))
        if let cgImages = itemsImage?.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) {
            for i in 0...typeCount-1 {
                let progress = CGFloat(i + 1) / CGFloat(typeCount)
                onProgressAction?(progress)
                //let type = ItemType.allCases[i]

                let rect = CGRect(x: iX, y: 256 * 5 - iY, width: 256, height: 256)
                if let cgImage = cgImages.cropping(to: rect) {
                    let image = NSImage(cgImage: cgImage, size: CGSize(width: 256, height: 256))
                    if let mat = baseMaterial.copy() as? SCNMaterial {
                        mat.diffuse.contents = image
                        materials.append(mat)
                    }
                }
                iX += 256
                if (iX >= 256 * 6) {
                    iX = 0
                    iY += 256
                }
            }
        }
    }

    func createMaterialsOld(onProgressAction: ((_: CGFloat) -> Void)?) {
        if materials.count > 0 {
            return
        }

        var returnImage = createEmptyImage()

        returnImage.draw(in: CGRect(origin: .zero, size: CGSize(width: 256 * 6, height: 256 * 6)))

        var iX: CGFloat = 0
        var iY: CGFloat = 0
        let typeCount = ItemType.allCases.count
        for i in 0...typeCount-1 {
            let progress = CGFloat(i + 1) / CGFloat(typeCount)
            onProgressAction?(progress)
            let type = ItemType.allCases[i]

//            var returnImage = createEmptyImage()
//            var imageRect = CGRect(x: 0, y: 0, width: 256, height: 256)
//            if let returnCGImage = returnImage.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) {
//                if let image = NSImage(named: type.imageName) {
//                    if let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil) {
//                        returnCGImage.cropping(to: <#T##CGRect#>)
//                        print(imageRef)
//                    }
//                }
//            }

//            let image = NSImage()
//            image.lockFocus()
//            //draw your stuff here
//
//            image.draw(in: CGRect(origin: .zero, size: size))
//            // x:140
//            let frame2 = CGRect(x: x, y: y, width: size.width/scale, height: size.height/scale)
//            image.draw(in: frame2)
//
//            image.unlockFocus()
//            return image

//            var returnImage = createEmptyImage()
//            returnImage.lockFocus()
//            //draw your stuff here
//
//            returnImage.draw(in: CGRect(origin: .zero, size: returnImage.size))
//
//
//            let frame2 = CGRect(x: x, y: y, width: size.width/scale, height: size.height/scale)
//            topImage.draw(in: frame2)
//
//            returnImage.unlockFocus()

            if let image = NSImage(named: type.imageName) {
                let rect = CGRect(x: iX, y: iY, width: 256, height: 256)
                returnImage = merge(bottomImage: returnImage, topImage: image, rect: rect)
                iX += 256
                if (iX >= 256 * 6) {
                    iX = 0
                    iY += 256
                }
            }

            //if let image = NSImage(named: type.imageName) {
                if let mat = baseMaterial.copy() as? SCNMaterial {
                    mat.diffuse.contents = type.imageName
                    materials.append(mat)
                }
            //}
        }
        let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        let destinationURL = url.appendingPathComponent("items.png")
        returnImage.pngWrite(to: destinationURL, options: .withoutOverwriting)
    }

    func getMaterial(by type: ItemType) -> SCNMaterial {
        return materials[type.rawValue]
    }

    func getBaseMaterial() -> SCNMaterial{
        return baseMaterial
    }
}
