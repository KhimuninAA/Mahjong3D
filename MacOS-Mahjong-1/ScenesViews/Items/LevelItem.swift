//
//  LevelItem.swift
//  Mahjong
//
//  Created by Алексей Химунин on 25.07.2023.
//

import Foundation

enum LevelType: Int, CaseIterable {
    
    case winds4 //4_winds
    case alien
    case altar
    case arena
    case arrow
    case atlantis
    case aztec
    
    case `default`
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
        var name = "\(self)"
        if name == "winds4" {
            name = "4_winds"
        }
        return LayoutLevels.getLevel(name: name)
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
        
        for itemCase in LevelType.allCases {
            let str = "l_\(itemCase)"
            levels.append(LevelItem(name: str, type: itemCase))
        }
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
