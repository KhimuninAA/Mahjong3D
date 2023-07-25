//
//  LevelItem.swift
//  Mahjong
//
//  Created by Алексей Химунин on 25.07.2023.
//

import Foundation

enum LevelType: Int, CaseIterable {
    case level1
    case level2
}

extension LevelType {
    func levelPos() -> [Pos] {
        let level: [Pos]
        switch self {
        case .level1:
            level = Level.level2()
        case .level2:
            level = Level.level3()
        }
        return level
    }
}

struct LevelItem {
    let name: String
    let type: LevelType
}

// http://www.247mahjong.com/
// KDE https://github.com/KDE/kmahjongg/blob/master/layouts/pyramid.layout
extension LevelItem {
    static func getLevels() -> [LevelItem] {
        var levels = [LevelItem]()

        levels.append(LevelItem(name: "стандартная", type: .level1))
        levels.append(LevelItem(name: "пирамида", type: .level2))

        return levels
    }
}

struct LevelsData {
    let levels: [LevelItem]
    var currentIndex: Int
}

extension LevelsData {
    static func create() -> LevelsData {
        let type = Storage.readLevelType()
        return LevelsData(levels: LevelItem.getLevels(), currentIndex: type.rawValue)
    }

    func currentLevel() -> LevelItem {
        let type = LevelType(rawValue: self.currentIndex)
        for level in self.levels {
            if level.type == type {
                return level
            }
        }
        return self.levels[0]
    }
}
