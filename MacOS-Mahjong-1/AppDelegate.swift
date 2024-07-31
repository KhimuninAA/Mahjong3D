//
//  AppDelegate.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 20.07.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate, NSMenuDelegate {

    var rootView: RootView?
    @IBOutlet var window: NSWindow!
    private var startUsedMB: Double = 0

    func applicationWillFinishLaunching(_ notification: Notification) {
        window.alphaValue = 0

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didWindowChange),
            name: NSWindow.didMoveNotification,
            object: nil
        )
    }

    @objc func didWindowChange() {
        saveWindowFrame()
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //-- frame from storage
        let wFrame = Storage.readWindowFrame()
        if wFrame.width > 50 && wFrame.height > 50 {
            window.setFrame(wFrame, display: true)
        }
        //---
        rootView = RootView()
        rootView?.onUpdateLevelsAction = { [weak self] in
            self?.updateLevels()
        }
        rootView?.onResizeAction = { [weak self] in
            self?.saveWindowFrame()
        }
        window.contentView = rootView
        window.delegate = self
        window.menu?.delegate = self
        self.window.title = NSLocalizedString("Mahjong 3D", comment: "")
        window.alphaValue = 1
        updateLevels()
        updateFollowCursor()

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            if let usedMBStr = self?.formattedMemoryFootprint() as? String {
                print(usedMBStr)
            }
        })
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(self)
        saveWindowFrame()
        return false
    }

    private func saveWindowFrame() {
        let frame = window.frame
        Storage.save(windowFrame: frame)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func showLevel(_ sender: Any) {
        rootView?.showLevels()
    }

    @IBAction func newGame(_ sender: Any) {
        rootView?.newGame()
    }

    @IBAction func showAbout(_ sender: Any) {
        if let mainSize = NSScreen.main?.frame.size{
            let aboutSize = CGSize(width: 400, height: 200)
            let aboutFrame = CGRect(x: 0.5 * (mainSize.width - aboutSize.width), y: 0.5 * (mainSize.height - aboutSize.height), width: aboutSize.width, height: aboutSize.height)
            let aboutView = AboutView(frame: aboutFrame)
            openInWindow(view: aboutView, rect: aboutFrame, title: "О программе", isShowBar: true)
            preferenceWindow?.makeKeyAndOrderFront(self)
        }
    }

    @IBAction func followCursor(_ sender: Any) {
        let isFollowCursor = Storage.readFollowCursor()
        Storage.saveFollowCursor(val: !isFollowCursor)
        updateFollowCursor()
    }
    
    private func updateFollowCursor() {
        if let menuItem = getMenuItem(from: window.menu, name: "follow_cursor") {
            let isFollowCursor = Storage.readFollowCursor()
            let subStr: String
            if isFollowCursor {
                subStr = NSLocalizedString("v_enable", comment: "")
            } else {
                subStr = NSLocalizedString("v_disable", comment: "")
            }
            let str = NSLocalizedString("Follow the cursor", comment: "")
            menuItem.title = str + " : " + subStr
        }
    }
    
    @IBAction func showHelp(_ sender: Any) {
        if let mainSize = NSScreen.main?.frame.size{
            let helpSize = CGSize(width: 400, height: 440)
            let helpFrame = CGRect(x: 0.5 * (mainSize.width - helpSize.width), y: 0.5 * (mainSize.height - helpSize.height), width: helpSize.width, height: helpSize.height)
            let helpView = HelpView(frame: helpFrame)
            openInWindow(view: helpView, rect: helpFrame, title: "О программе", isShowBar: true)
            preferenceWindow?.makeKeyAndOrderFront(self)
        }
    }

    private var preferenceWindow: NSWindow?
    private func openInWindow(view: NSView, rect: CGRect, title: String, isShowBar: Bool){
        if preferenceWindow != nil {
            preferenceWindow?.orderOut(self)
            preferenceWindow = nil
        }

        preferenceWindow = NSWindow(contentRect: rect, styleMask: [.closable, .titled, .unifiedTitleAndToolbar], backing: .buffered, defer: false)
        if isShowBar{
            preferenceWindow?.titlebarAppearsTransparent = true
            preferenceWindow?.titleVisibility = .hidden
        }
        preferenceWindow?.delegate = self
        preferenceWindow?.title = title
        preferenceWindow?.contentView = view
        preferenceWindow?.contentView?.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
    }

    private func updateLevels() {
        if let menuItem = getMenuItem(from: window.menu, name: "game") {
            if let levelItem = getMenuItem(from: menuItem.submenu, name: "level") {
                levelItem.submenu = NSMenu()
                if let levelData = rootView?.scene?.getLevelData() {
                    let currentLevel = levelData.currentLevel()
                    LevelImageCashe.updateImageCashe(levelsData: levelData, onComplition: { [weak self] in
                        self?.updateLevels()
                    })
                    for level in levelData.levels {
                        let mItem = NSMenuItem(title: NSLocalizedString(level.name, comment: ""), action: #selector(AppDelegate.levelAction), keyEquivalent: "")
                        mItem.tag = level.type.rawValue
                        if currentLevel.type == level.type {
                            mItem.image = NSImage(named: "check_icon16")
                        }
                        mItem.image = LevelImageCashe.getImageForMenu(by: level.name)
                        levelItem.submenu?.addItem(mItem)
                    }
                }
            }
        }
    }

    @objc func levelAction(item: NSMenuItem) {
        rootView?.levelsViewClear()
        DispatchQueue.main.async { [weak self] in
            self?.rootView?.scene?.setLevelIndex(item.tag)
            self?.updateLevels()
        }
    }


}

extension AppDelegate {
    func getMenuItem(from menu: NSMenu?, name: String) -> NSMenuItem? {
        if let menu = menu {
            for item in menu.items {
                if let identifier = item.identifier?.rawValue as? String, identifier == name {
                    return item
                }
                if let subMenu = item.submenu {
                    if let subItem = getMenuItem(from: subMenu, name: name) {
                        return subItem
                    }
                }
            }
        }
        return nil
    }
}

extension AppDelegate {
    func memoryFootprint() -> Float? {
        // The `TASK_VM_INFO_COUNT` and `TASK_VM_INFO_REV1_COUNT` macros are too
        // complex for the Swift C importer, so we have to define them ourselves.
        let TASK_VM_INFO_COUNT = mach_msg_type_number_t(MemoryLayout<task_vm_info_data_t>.size / MemoryLayout<integer_t>.size)
        let TASK_VM_INFO_REV1_COUNT = mach_msg_type_number_t(MemoryLayout.offset(of: \task_vm_info_data_t.min_address)! / MemoryLayout<integer_t>.size)
        var info = task_vm_info_data_t()
        var count = TASK_VM_INFO_COUNT
        let kr = withUnsafeMutablePointer(to: &info) { infoPtr in
            infoPtr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { intPtr in
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), intPtr, &count)
            }
        }
        guard
            kr == KERN_SUCCESS,
            count >= TASK_VM_INFO_REV1_COUNT
        else { return nil }

        let usedBytes = Float(info.phys_footprint)
        return usedBytes

    }

    func formattedMemoryFootprint() -> String {
        let usedBytes: UInt64? = UInt64(self.memoryFootprint() ?? 0)
        let usedMB = Double(usedBytes ?? 0) / 1024 / 1024
        if startUsedMB == 0 {
            startUsedMB = usedMB
        }

        let usedMBr = round(usedMB)
        let up = round(1000 * (usedMB - startUsedMB) / startUsedMB) / 100
        let usedMBAsString: String = "Memory Used by App: \(usedMBr)MB, Up: \(up)%"
        return usedMBAsString
    }
}
