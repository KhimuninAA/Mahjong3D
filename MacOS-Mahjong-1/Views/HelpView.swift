//
//  HelpView.swift
//  ColorLines3D
//
//  Created by Алексей Химунин on 11.01.2023.
//

import Foundation
import Cocoa

class HelpView: NSView{
    private var logoView: NSImageView?
    private var appNameLabel: KhLabel?
    private var appVersionLabel: KhLabel?
    private var helpText: NSTextField?
    
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
        let appNameString = dictionary["CFBundleName"] as! String
        let bundleVersionString = dictionary["CFBundleVersion"] as! String
        let shortVersionInt = Int(Float(shortVersionString) ?? 0)
        

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
        
        helpText = NSTextField(frame: .zero)
        if let helpText = helpText{
            helpText.isBezeled = false
            helpText.isEditable = false
            helpText.drawsBackground = false
            //helpText.isSelectable = false
            helpText.stringValue = "    Принцип построения и механизм игры очень похож на карточный: на столе выкладывается определённая конфигурация из предварительно перемешанных костей («классических» раскладок существует несколько десятков, большинство из них многослойные). \n\r    Цель игры состоит в том, чтобы полностью разобрать конструкцию, удаляя из неё, следуя определённым правилам, пары одинаковых костей. Как и в случае карточных пасьянсов, не все варианты раскладок решаемы."
            addSubview(helpText)
        }
        
        resizeSubviews(withOldSize: frame.size)
    }
    
    override func resizeSubviews(withOldSize oldSize: NSSize) {
        super.resizeSubviews(withOldSize: oldSize)
        
        let selfSize = frame.size
        let padding: CGFloat = 16
        
        let logoSize = 0.5 * (selfSize.width - 2 * padding)
        let logoTop = selfSize.height - padding - logoSize
        
        let logoViewFrame = CGRect(x: padding, y: logoTop, width: logoSize, height: logoSize)
        self.logoView?.frame = logoViewFrame
        
        let left = logoViewFrame.maxX + padding
        let leftWidth = selfSize.width - left - padding
        
        let appNameLabelSize = appNameLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let appNameLabelTop = selfSize.height - padding - appNameLabelSize.height
        //selfSize.height - appNameLabelSize.height
        let appNameLabelFrame = CGRect(x: left, y: appNameLabelTop, width: leftWidth, height: appNameLabelSize.height)
        appNameLabel?.frame = appNameLabelFrame
        
        let appVersionLabelSize = appVersionLabel?.getSize() ?? CGSize(width: 0, height: 0)
        let appVersionLabelTop = appNameLabelFrame.minY - padding - appVersionLabelSize.height
        let appVersionLabelFrame = CGRect(x: left, y: appVersionLabelTop, width: leftWidth, height: appVersionLabelSize.height)
        appVersionLabel?.frame = appVersionLabelFrame
        
        let textHeight = logoTop - padding
        let textWidth = selfSize.width - 2 * padding
        let helpTextFrame = CGRect(x: padding, y: padding, width: textWidth, height: textHeight)
        helpText?.frame = helpTextFrame

    }
}
