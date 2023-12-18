//
//  Storage.swift
//  Mahjong
//
//  Created by Алексей Химунин on 25.07.2023.
//

import Foundation

class Storage {
    private static func storage() -> UserDefaults {
        return UserDefaults.standard
    }
    
    static func saveFollowCursor(val: Bool) {
        let storage = storage()
        storage.set(val, forKey: "FollowCursor")
    }
    
    static func readFollowCursor() -> Bool {
        let storage = storage()
        let value = storage.bool(forKey: "FollowCursor")
        return value
    }

    static func save(type: LevelType) {
        let storage = storage()
        storage.set(type.rawValue, forKey: "LevelType")
    }

    static func readLevelType() -> LevelType{
        let storage = storage()
        let typeValue = storage.integer(forKey: "LevelType")
        return LevelType(rawValue: typeValue) ?? LevelType.def
    }

    static func save(windowFrame: CGRect) {
        let storage = storage()
        storage.setValue(windowFrame.minX, forKey: "windowFrameX")
        storage.setValue(windowFrame.minY, forKey: "windowFrameY")
        storage.setValue(windowFrame.width, forKey: "windowFrameW")
        storage.setValue(windowFrame.height, forKey: "windowFrameH")
    }

    static func readWindowFrame() -> CGRect {
        let storage = storage()
        let windowFrameX = storage.integer(forKey: "windowFrameX")
        let windowFrameY = storage.integer(forKey: "windowFrameY")
        let windowFrameW = storage.integer(forKey: "windowFrameW")
        let windowFrameH = storage.integer(forKey: "windowFrameH")
        let frame = CGRect(x: windowFrameX, y: windowFrameY, width: windowFrameW, height: windowFrameH)
        return frame
    }
}
