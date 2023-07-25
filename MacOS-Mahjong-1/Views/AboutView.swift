//
//  AboutView.swift
//  Sokoban3D
//
//  Created by Алексей Химунин on 02.06.2022.
//

import Foundation
import Cocoa

class KhLabel: NSTextField{
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        isBezeled = false
        isEditable = false
        drawsBackground = false
        isSelectable = false
    }
    
    func getSize() -> CGSize{
        sizeToFit()
        let size: CGSize = self.stringValue.size(withAttributes: [.font: self.font as Any])
        return size
    }
}

class AboutView: NSView{
    private var logoView: NSImageView?
    private var appNameLabel: KhLabel?
    private var appVersionLabel: KhLabel?
    private var devLabel: KhLabel?
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    private func initView(){
        logoView = NSImageView(frame: .zero)
        if let logoView = logoView{
            logoView.image = NSImage(named: "AppIcon") 
            logoView.imageScaling = .scaleProportionallyDown
            addSubview(logoView)
        }
        
        let dictionary = Bundle.main.infoDictionary!
        let shortVersionString = dictionary["CFBundleShortVersionString"] as! String
        let shortVersionInt = Int(Float(shortVersionString) ?? 0)
        let appNameString = dictionary["CFBundleName"] as! String
        let bundleVersionString = dictionary["CFBundleVersion"] as! String
        

        appNameLabel = KhLabel(frame: .zero)
        if let appNameLabel = appNameLabel{
            appNameLabel.stringValue = appNameString
            appNameLabel.font = NSFont(name: "Menlo", size: 23)
            addSubview(appNameLabel)
        }
        
        appVersionLabel = KhLabel(frame: .zero)
        if let appVersionLabel = appVersionLabel{
            appVersionLabel.stringValue = "Version \(shortVersionString) (\(shortVersionInt)E\(bundleVersionString))"
            appVersionLabel.font = NSFont(name: "Menlo", size: 13)
            addSubview(appVersionLabel)
        }
        
        devLabel = KhLabel(frame: .zero)
        if let devLabel = devLabel{
            devLabel.stringValue = "Алексей Химунин (khimuninaa@gmail.com)"
            devLabel.font = NSFont(name: "Menlo", size: 7)
            addSubview(devLabel)
        }

        resizeSubviews(withOldSize: frame.size)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        let selfSize = frame.size
        let padding: CGFloat = 16
        
        let logoSize = selfSize.height - 2 * padding
        
        let logoViewFrame = CGRect(x: padding, y: padding, width: logoSize, height: logoSize)
        logoView?.frame = logoViewFrame
        
        let left = logoViewFrame.maxX + padding
        let leftWidth = selfSize.width - left - padding
        
        let appNameLabelSize = appNameLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let appNameLabelTop = selfSize.height - appNameLabelSize.height
        let appNameLabelFrame = CGRect(x: left, y: appNameLabelTop, width: leftWidth, height: appNameLabelSize.height)
        appNameLabel?.frame = appNameLabelFrame
        
        let appVersionLabelSize = appVersionLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let appVersionLabelTop = appNameLabelFrame.minY - padding - appVersionLabelSize.height
        let appVersionLabelFrame = CGRect(x: left, y: appVersionLabelTop, width: leftWidth, height: appVersionLabelSize.height)
        appVersionLabel?.frame = appVersionLabelFrame

        let devLabelSize = devLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let devLabelFrame = CGRect(x: left, y: padding, width: leftWidth, height: devLabelSize.height)
        devLabel?.frame = devLabelFrame
    }
}
