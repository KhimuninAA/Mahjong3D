//
//  ScenesView.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 20.07.2023.
//

import Foundation
import SceneKit
import AVFAudio

class SceneView: SCNView {
    var lightNode: SCNNode?
    var cameraNode: SCNNode?
    var doskaNode: SCNNode?
    var lightTick: CGFloat = 0
    var selectItemNode: ItemNone?
    var centerPoint: CGPoint = CGPoint(x: 0, y: 0)
    private var materialUtils = MaterialUtils()
    private var overlayScene: OverlayScene?

    override init(frame: NSRect, options: [String : Any]? = nil) {
        super.init(frame: frame, options: options)
        initView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }

    private func initLightNode(){
        lightNode = scene?.rootNode.childNode(withName: "omni", recursively: true)
        if let lightNode = lightNode{
            lightNode.light?.castsShadow = true
            lightNode.light?.automaticallyAdjustsShadowProjection = true
            lightNode.light?.maximumShadowDistance = 0 //100//20.0
            //lightNode?.light?.orthographicScale = 1

            //lightNode?.light?.shadowMapSize = CGSize(width: 2048, height: 2048)
            lightNode.light?.shadowMapSize = CGSize(width: 4000, height: 4000)
            lightNode.light?.orthographicScale=100; // bigger is softer
            lightNode.light?.shadowMode = .forward // forward deferred modulated
            lightNode.light?.shadowSampleCount = 128
            lightNode.light?.shadowRadius = 10 //100
            lightNode.light?.shadowBias  = 0.01 //0.1 //5//32
            
            lightNode.light?.shadowColor                   = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 1) //UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
            //lightNode.light?.shadowMode                    = .deferred
            //lightNode.light?.shadowRadius                  = 2.0  // 3.25 // suggestion by StackOverflow
            lightNode.light?.shadowCascadeCount            = 3    // suggestion by lightNode
            lightNode.light?.shadowCascadeSplittingFactor  = 0.09 // suggestion by StackOverflow
        }
    }
    
    private func initCameraNode(){
        cameraNode = scene?.rootNode.childNode(withName: "camera", recursively: true)
    }
    
    private func createDoska() {
        let doskaGeometry: SCNGeometry = SCNBox(width: 20, height: 0.01, length: 12, chamferRadius: 0)
        doskaNode = SCNNode(geometry: doskaGeometry)
        doskaNode?.position = SCNVector3Make(-0, -0, -0)
        
        let itemMaterial = SCNMaterial.init()
        itemMaterial.locksAmbientWithDiffuse = true
        itemMaterial.diffuse.contents = nil
        itemMaterial.lightingModel = .physicallyBased
        itemMaterial.isDoubleSided = false
        itemMaterial.diffuse.contents = NSImage(named: "TexturesCom_Wood_TeakVeneer_512_albedo")
        itemMaterial.normal.contents = NSImage(named: "TexturesCom_Wood_TeakVeneer_512_normal")
        itemMaterial.roughness.contents = NSImage(named: "TexturesCom_Wood_TeakVeneer_512_roughness")
        
        itemMaterial.diffuse.contentsTransform = SCNMatrix4MakeScale(2, 2, 1)
        itemMaterial.normal.contentsTransform = SCNMatrix4MakeScale(2, 2, 1)
        itemMaterial.roughness.contentsTransform = SCNMatrix4MakeScale(2, 2, 1)

        itemMaterial.diffuse.wrapS = .repeat
        itemMaterial.diffuse.wrapT = .repeat
        
        itemMaterial.normal.wrapS = .repeat
        itemMaterial.normal.wrapT = .repeat
        
        itemMaterial.roughness.wrapS = .repeat
        itemMaterial.roughness.wrapT = .repeat
        
        doskaNode?.geometry?.materials = [itemMaterial]
        
        if let doskaNode = doskaNode {
            self.scene?.rootNode.addChildNode(doskaNode)
        }
    }

    private func initView() {
        self.delegate = self
        self.loops = true
        self.isPlaying = true

        scene = SCNScene(named: "SKScene.scnassets/Scene.scn")

        self.isJitteringEnabled = true
        
        overlayScene = OverlayScene(size: bounds.size)
        overlayScene?.isHelpAction = { [weak self] in
            self?.showAccessDouble()
        }
        if let overlayScene = overlayScene{
            overlayScene.scaleMode = .resizeFill
            self.overlaySKScene = overlayScene
        }
        
        //generatePNGs()
        createDoska()
        initLightNode()
        initCameraNode()
        createPole()

    }
    
    func newGame() {
        if let childNodes = self.doskaNode?.childNodes {
            for childNode in childNodes {
                if let childNode = childNode as? ItemNone {
                    childNode.remove()
                }
            }
        }
        lightTick = 0
        selectItemNode = nil
        centerPoint = CGPoint(x: 0, y: 0)
        createPole()
    }

    private func createPole() {
        overlayScene?.progressViewHidden(false)
        doskaNode?.isHidden = true
        let baseMaterial = materialUtils.getBaseMaterial()
        let level = Level.level2()

        //144
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        var minX: CGFloat = CGFLOAT_MAX
        var minY: CGFloat = CGFLOAT_MAX
        
        //background userInitiated
        //DispatchQueue.global(qos: .background).async { [weak self] in
            // All types
            self.materialUtils.createMaterials(onProgressAction: { [weak self] progress in
                self?.overlayScene?.progressViewSetProgress(progress)
            })

            let typeCount = ItemType.allCases.count
            var types: [ItemType] = [ItemType]()
            for i in 0...typeCount-1 {
                for _ in 0...3 {
                    types.append(ItemType.allCases[i])
                }
            }
            
            for pos in level {
                let progress = CGFloat(level.count - types.count)/CGFloat(level.count)
                self.overlayScene?.progressViewSetProgress(progress)
                //
                let typesCount = types.count
                let currentType: ItemType
                if typesCount > 0 {
                    let index = Int.random(in: 0...typesCount-1)
                    currentType = types[index]
                    types.remove(at: index)
                } else {
                    currentType = .haku
                    print("Add haku!!!!!")
                }
                //
                let material = self.materialUtils.getMaterial(by: currentType) ?? SCNMaterial()
                let item = ItemNone.make(baseMaterial: baseMaterial, material: material, type: currentType)
                item.pos = pos
                item.position = item.defaultVector3()
                self.doskaNode?.addChildNode(item)
                if maxX < item.position.x {
                    maxX = item.position.x
                }
                if maxY < item.position.z {
                    maxY = item.position.z
                }
                
                if minX > item.position.x {
                    minX = item.position.x
                }
                if minY > item.position.z {
                    minY = item.position.z
                }
            }
            let cen = CGPoint(x: minX + (maxX - minX) * 0.5, y: minY + (maxY - minY) * 0.5)
            self.centerPoint = cen

            //DispatchQueue.main.async { [weak self] in
                self.calcGameInfo()
                self.updateCameraAndDoska()
            //}
        //}
    }
    
    private func updateCameraAndDoska() {
        if let doskaNode = doskaNode, let cameraNode = cameraNode {
            doskaNode.pivot = SCNMatrix4MakeTranslation(centerPoint.x, 0, centerPoint.y);
            doskaNode.position = SCNVector3Make(centerPoint.x, 0, centerPoint.y)
            let z = 2 * max(centerPoint.x - ItemNone.paddingTop, centerPoint.y - ItemNone.paddingLeft) + 1
            cameraNode.position = SCNVector3Make(centerPoint.x, z, centerPoint.y)
        }
        overlayScene?.progressViewHidden(true)
        doskaNode?.isHidden = false
    }
}

extension SceneView: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if let lightNode = lightNode{
            lightTick += 0.001
            let radius: CGFloat = 20
            let x = centerPoint.x + radius * sin(lightTick)
            let y = centerPoint.y + radius * cos(lightTick)

            lightNode.position = SCNVector3Make(x, 20, y)
        }
    }
}

extension SceneView {
    func resizeView() {
        let selfSize = bounds.size
        overlayScene?.layout2DOverlay(newSize: selfSize)
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        let opt = (
            NSTrackingArea.Options.mouseEnteredAndExited.rawValue |
                NSTrackingArea.Options.mouseMoved.rawValue |
                NSTrackingArea.Options.activeAlways.rawValue
        )

        let turnPageTrackingArea = NSTrackingArea(rect: self.bounds, options: NSTrackingArea.Options(rawValue: opt), owner: self, userInfo: nil)
        self.addTrackingArea(turnPageTrackingArea)
    }
    
    override func mouseMoved(with event: NSEvent) {
        super.mouseMoved(with: event)
        let windowPoint = event.locationInWindow
        let sizeX = self.bounds.size.width * 0.5
        let sizeY = self.bounds.size.height * 0.5

        let x = (sizeX - windowPoint.x)/sizeX
        let y = (sizeY - windowPoint.y)/sizeY
        
        if let doskaNode = doskaNode {
            //let angle = CGFloat.pi * sin(lightTick * 5) * 0.05
            let angleX = CGFloat.pi * x * 0.05
            let angleY = CGFloat.pi * y * 0.05
            doskaNode.eulerAngles = SCNVector3Make(-angleY, 0, -angleX)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        let result = hitTestResultForEvent(event)

        if let itemNode = result?.node as? ItemNone {
            if itemNode != selectItemNode && accessSelected(item: itemNode) {
                if itemNode.type == selectItemNode?.type {
                    itemNode.setSelected(true)
                    Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false, block: { [weak self] _ in
                        itemNode.setSelected(false)
                        self?.selectItemNode?.setSelected(false)
                        self?.selectItemNode?.remove()
                        itemNode.remove()
                        self?.selectItemNode = nil
                        self?.calcGameInfo()
                    })
                } else {
                    itemNode.setSelected(true)
                    selectItemNode?.setSelected(false)
                    selectItemNode = itemNode
                }
            } else {
                selectItemNode?.setSelected(false)
                self.selectItemNode = nil
            }
        } else {
            if let selectItemNode = selectItemNode {
                selectItemNode.setSelected(false)
                self.selectItemNode = nil
            }
        }
    }
    
    func hitTestResultForEvent(_ event: NSEvent) -> SCNHitTestResult?{
        let viewPoint = viewPointForEvent(event)
        let cgPoint = CGPoint(x: viewPoint.x, y: viewPoint.y)
        let points = self.hitTest(cgPoint, options: [:])
        return points.first
    }

    func viewPointForEvent(_ event: NSEvent) -> NSPoint{
        let windowPoint = event.locationInWindow
        let viewPoint = self.convert(windowPoint, from: nil)
        return viewPoint
    }
    
    private func accessSelected(item: ItemNone) -> Bool {
        var top: Bool = true
        var right: Bool = true
        var left: Bool = true
        if let childNodes = self.doskaNode?.childNodes {
            for childNode in childNodes {
                if let childNode = childNode as? ItemNone, childNode != item {
                    //TOP
                    if childNode.pos.z - 1 == item.pos.z &&
                        childNode.pos.x - 0.5 <= item.pos.x && childNode.pos.x + 0.5 >= item.pos.x &&
                        childNode.pos.y - 0.5 <= item.pos.y && childNode.pos.y + 0.5 >= item.pos.y
                    {
                        top = false
                    }
                    //LEFT and RIGHT
                    if childNode.pos.z == item.pos.z &&
                        childNode.pos.y - 0.5 <= item.pos.y && childNode.pos.y + 0.5 >= item.pos.y {
                        //LEFT
                        if childNode.pos.x <= item.pos.x && childNode.pos.x + 1 >= item.pos.x {
                            left = false
                        }
                        //RIGHT
                        if childNode.pos.x - 1 <= item.pos.x && childNode.pos.x >= item.pos.x {
                            right = false
                        }
                    }
                }
            }
        }
        return top && (left || right)
    }
    
    private func generatePNG(image: NSImage, url: URL, type: ItemType) {
        if let typeImage = NSImage(named: type.imageName) {
            let newImage = ItemNone.merge(bottomImage: image, topImage: typeImage)
            let destinationURL = url.appendingPathComponent(type.imageName + ".png")
            if newImage.pngWrite(to: destinationURL, options: .withoutOverwriting) {
                print("File " + type.imageName + " saved")
            }
        }
    }
    
    private func generatePNGs() {
        let diffuseImage = NSImage(named: "TexturesCom_Metal_SteelRough2_1K_ao")
        let url = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!
        if let diffuseImage = diffuseImage {
            
            generatePNG(image: diffuseImage, url: url, type: .flow1)
            generatePNG(image: diffuseImage, url: url, type: .flow2)

        }
    }
    
    func calcGameInfo() {
        var count: Int = 0
        var doubleCount: Int = 0
        var accessedItems = [ItemNone]()
        if let childNodes = self.doskaNode?.childNodes {
            for childNode in childNodes {
                if let childNode = childNode as? ItemNone {
                    count += 1
                    if accessSelected(item: childNode) {
                        accessedItems.append(childNode)
                    }
                }
            }
        }
        if count == 0 {
            //WINE!!!
        }
        if accessedItems.count > 1 {
            let groupItems = Dictionary(grouping: accessedItems, by: { $0.type })
            let keys = Array(groupItems.keys)
            for key in keys {
                if let items = groupItems[key] {
                    if items.count > 1 {
                        if items.count == 2 {
                            doubleCount += 1
                        } else {
                            doubleCount += 2
                        }
                    }
                }
            }
        } else {
            //Game ower
            
        }
        
        overlayScene?.setValue(doubleCount: doubleCount, itemCount: count)
    }
    
    func showAccessDouble() {
        var accessedItems = [ItemNone]()
        if let childNodes = self.doskaNode?.childNodes {
            for childNode in childNodes {
                if let childNode = childNode as? ItemNone {
                    if accessSelected(item: childNode) {
                        accessedItems.append(childNode)
                    }
                }
            }
        }
        var accessItems = [[ItemNone]]()
        let groupItems = Dictionary(grouping: accessedItems, by: { $0.type })
        let keys = Array(groupItems.keys)
        for key in keys {
            if let items = groupItems[key] {
                if items.count > 1 {
                    accessItems.append(items)
                }
            }
        }
        let count = accessItems.count
        if count > 0 {
            let index = Int.random(in: 0...count-1)
            let items = accessItems[index]
            items[0].showHelp()
            items[1].showHelp()
        }
    }
}
