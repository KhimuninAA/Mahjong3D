//
//  LevelItem.swift
//  Mahjong
//
//  Created by Алексей Химунин on 25.07.2023.
//

import Foundation

enum LevelType: Int, CaseIterable {
    case def
    case pyramid
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

    case test4x4
}

extension LevelType {
    func levelPos() -> [Pos] {
        let level: [Pos]
        switch self {
        case .def:
            level = LayoutLevels.getLevel(name: "default")
        case .pyramid:
            level = LayoutLevels.getLevel(name: "pyramid")
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
        case .test4x4:
            level = LayoutLevels.getLevel(name: "test4x4")
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

        levels.append(LevelItem(name: "l_default", type: .def))
        levels.append(LevelItem(name: "l_pyramid", type: .pyramid))
        levels.append(LevelItem(name: "l_rocket", type: .rocket))
        levels.append(LevelItem(name: "l_grid", type: .grid))
        levels.append(LevelItem(name: "l_glade", type: .glade))
        levels.append(LevelItem(name: "l_girl", type: .girl))
        levels.append(LevelItem(name: "l_eagle", type: .eagle))
        levels.append(LevelItem(name: "l_enterprise", type: .enterprise))
        levels.append(LevelItem(name: "l_explosion", type: .explosion))
        levels.append(LevelItem(name: "l_flowers", type: .flowers))
        levels.append(LevelItem(name: "l_galaxy", type: .galaxy))
        levels.append(LevelItem(name: "l_garden", type: .garden))
        levels.append(LevelItem(name: "l_future", type: .future))
        levels.append(LevelItem(name: "l_dragon", type: .dragon))


        levels.append(LevelItem(name: "test4x4", type: .test4x4))        
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
