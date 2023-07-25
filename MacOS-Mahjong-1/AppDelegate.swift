//
//  AppDelegate.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 20.07.2023.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {

    var rootView: RootView?
    @IBOutlet var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        rootView = RootView()
        window.contentView = rootView
        window.delegate = self
        self.window.title = "Mahjong 3D"
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func windowShouldClose(_ sender: NSWindow) -> Bool {
        sender.orderOut(self)
        return false
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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

    @IBAction func showHelp(_ sender: Any) {
        if let mainSize = NSScreen.main?.frame.size{
            let helpSize = CGSize(width: 400, height: 400)
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

}

