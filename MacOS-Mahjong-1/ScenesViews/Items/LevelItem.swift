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
    case rocket
    case grid
    case glade
    case girl

    case eagle
    case enterprise
    case explosion
    case flowers
    case galaxy
    case garden
    case future
    
    case dragon
}

extension LevelType {
    func levelPos() -> [Pos] {
        let level: [Pos]
        switch self {
        case .level1:
            level = Level.level2()
        case .level2:
            level = Level.level3()
        case .rocket:
            level = LayoutLevels.getLevel(name: "rocket")
        case .grid:
            level = LayoutLevels.getLevel(name: "grid")
        case .glade:
            level = LayoutLevels.getLevel(name: "glade")
        case .girl:
            level = LayoutLevels.getLevel(name: "girl")
        case .eagle:
            level = LayoutLevels.getLevel(name: "eagle")
        case .enterprise:
            level = LayoutLevels.getLevel(name: "enterprise")
        case .explosion:
            level = LayoutLevels.getLevel(name: "explosion")
        case .flowers:
            level = LayoutLevels.getLevel(name: "flowers")
        case .galaxy:
            level = LayoutLevels.getLevel(name: "galaxy")
        case .garden:
            level = LayoutLevels.getLevel(name: "garden")
        case .future:
            level = LayoutLevels.getLevel(name: "future")
        case .dragon:
            level = LayoutLevels.getLevel(name: "dragon")
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
        levels.append(LevelItem(name: "rocket", type: .rocket))
        levels.append(LevelItem(name: "grid", type: .grid))
        levels.append(LevelItem(name: "glade", type: .glade))
        levels.append(LevelItem(name: "girl", type: .girl))
        
        levels.append(LevelItem(name: "eagle", type: .eagle))
        levels.append(LevelItem(name: "enterprise", type: .enterprise))
        levels.append(LevelItem(name: "explosion", type: .explosion))
        levels.append(LevelItem(name: "flowers", type: .flowers))
        levels.append(LevelItem(name: "galaxy", type: .galaxy))
        levels.append(LevelItem(name: "garden", type: .garden))
        levels.append(LevelItem(name: "future", type: .future))
        
        levels.append(LevelItem(name: "dragon", type: .dragon))
        
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
