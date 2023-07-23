//
//  Level.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 20.07.2023.
//

import Foundation

class Level{
    static func level1() -> [Pos] {
        var level = [Pos]()

        level.append(Pos(x: 1, y: 1, z: 1))
        level.append(Pos(x: 1, y: 2, z: 1))
        level.append(Pos(x: 2, y: 1, z: 1))
        level.append(Pos(x: 2, y: 2, z: 1))

        return level
    }
    
    static func level2() -> [Pos] {
        var level = [Pos]()

        level.append(Pos(x: 2, y: 1, z: 1))
        level.append(Pos(x: 3, y: 1, z: 1))
        level.append(Pos(x: 4, y: 1, z: 1))
        level.append(Pos(x: 5, y: 1, z: 1))
        level.append(Pos(x: 6, y: 1, z: 1))
        level.append(Pos(x: 7, y: 1, z: 1))
        level.append(Pos(x: 8, y: 1, z: 1))
        level.append(Pos(x: 9, y: 1, z: 1))
        level.append(Pos(x: 10, y: 1, z: 1))
        level.append(Pos(x: 11, y: 1, z: 1))
        level.append(Pos(x: 12, y: 1, z: 1))
        level.append(Pos(x: 13, y: 1, z: 1))
        
        level.append(Pos(x: 4, y: 2, z: 1))
        level.append(Pos(x: 5, y: 2, z: 1))
        level.append(Pos(x: 6, y: 2, z: 1))
        level.append(Pos(x: 7, y: 2, z: 1))
        level.append(Pos(x: 8, y: 2, z: 1))
        level.append(Pos(x: 9, y: 2, z: 1))
        level.append(Pos(x: 10, y: 2, z: 1))
        level.append(Pos(x: 11, y: 2, z: 1))
        
        level.append(Pos(x: 3, y: 3, z: 1))
        level.append(Pos(x: 4, y: 3, z: 1))
        level.append(Pos(x: 5, y: 3, z: 1))
        level.append(Pos(x: 6, y: 3, z: 1))
        level.append(Pos(x: 7, y: 3, z: 1))
        level.append(Pos(x: 8, y: 3, z: 1))
        level.append(Pos(x: 9, y: 3, z: 1))
        level.append(Pos(x: 10, y: 3, z: 1))
        level.append(Pos(x: 11, y: 3, z: 1))
        level.append(Pos(x: 12, y: 3, z: 1))
        
        level.append(Pos(x: 2, y: 4, z: 1))
        level.append(Pos(x: 3, y: 4, z: 1))
        level.append(Pos(x: 4, y: 4, z: 1))
        level.append(Pos(x: 5, y: 4, z: 1))
        level.append(Pos(x: 6, y: 4, z: 1))
        level.append(Pos(x: 7, y: 4, z: 1))
        level.append(Pos(x: 8, y: 4, z: 1))
        level.append(Pos(x: 9, y: 4, z: 1))
        level.append(Pos(x: 10, y: 4, z: 1))
        level.append(Pos(x: 11, y: 4, z: 1))
        level.append(Pos(x: 12, y: 4, z: 1))
        level.append(Pos(x: 13, y: 4, z: 1))
        
        level.append(Pos(x: 2, y: 5, z: 1))
        level.append(Pos(x: 3, y: 5, z: 1))
        level.append(Pos(x: 4, y: 5, z: 1))
        level.append(Pos(x: 5, y: 5, z: 1))
        level.append(Pos(x: 6, y: 5, z: 1))
        level.append(Pos(x: 7, y: 5, z: 1))
        level.append(Pos(x: 8, y: 5, z: 1))
        level.append(Pos(x: 9, y: 5, z: 1))
        level.append(Pos(x: 10, y: 5, z: 1))
        level.append(Pos(x: 11, y: 5, z: 1))
        level.append(Pos(x: 12, y: 5, z: 1))
        level.append(Pos(x: 13, y: 5, z: 1))
        
        level.append(Pos(x: 3, y: 6, z: 1))
        level.append(Pos(x: 4, y: 6, z: 1))
        level.append(Pos(x: 5, y: 6, z: 1))
        level.append(Pos(x: 6, y: 6, z: 1))
        level.append(Pos(x: 7, y: 6, z: 1))
        level.append(Pos(x: 8, y: 6, z: 1))
        level.append(Pos(x: 9, y: 6, z: 1))
        level.append(Pos(x: 10, y: 6, z: 1))
        level.append(Pos(x: 11, y: 6, z: 1))
        level.append(Pos(x: 12, y: 6, z: 1))
        
        level.append(Pos(x: 4, y: 7, z: 1))
        level.append(Pos(x: 5, y: 7, z: 1))
        level.append(Pos(x: 6, y: 7, z: 1))
        level.append(Pos(x: 7, y: 7, z: 1))
        level.append(Pos(x: 8, y: 7, z: 1))
        level.append(Pos(x: 9, y: 7, z: 1))
        level.append(Pos(x: 10, y: 7, z: 1))
        level.append(Pos(x: 11, y: 7, z: 1))
        
        level.append(Pos(x: 2, y: 8, z: 1))
        level.append(Pos(x: 3, y: 8, z: 1))
        level.append(Pos(x: 4, y: 8, z: 1))
        level.append(Pos(x: 5, y: 8, z: 1))
        level.append(Pos(x: 6, y: 8, z: 1))
        level.append(Pos(x: 7, y: 8, z: 1))
        level.append(Pos(x: 8, y: 8, z: 1))
        level.append(Pos(x: 9, y: 8, z: 1))
        level.append(Pos(x: 10, y: 8, z: 1))
        level.append(Pos(x: 11, y: 8, z: 1))
        level.append(Pos(x: 12, y: 8, z: 1))
        level.append(Pos(x: 13, y: 8, z: 1))
        
        //2
        level.append(Pos(x: 5, y: 2, z: 2))
        level.append(Pos(x: 6, y: 2, z: 2))
        level.append(Pos(x: 7, y: 2, z: 2))
        level.append(Pos(x: 8, y: 2, z: 2))
        level.append(Pos(x: 9, y: 2, z: 2))
        level.append(Pos(x: 10, y: 2, z: 2))
        
        level.append(Pos(x: 5, y: 3, z: 2))
        level.append(Pos(x: 6, y: 3, z: 2))
        level.append(Pos(x: 7, y: 3, z: 2))
        level.append(Pos(x: 8, y: 3, z: 2))
        level.append(Pos(x: 9, y: 3, z: 2))
        level.append(Pos(x: 10, y: 3, z: 2))
        
        level.append(Pos(x: 5, y: 4, z: 2))
        level.append(Pos(x: 6, y: 4, z: 2))
        level.append(Pos(x: 7, y: 4, z: 2))
        level.append(Pos(x: 8, y: 4, z: 2))
        level.append(Pos(x: 9, y: 4, z: 2))
        level.append(Pos(x: 10, y: 4, z: 2))
        
        level.append(Pos(x: 5, y: 5, z: 2))
        level.append(Pos(x: 6, y: 5, z: 2))
        level.append(Pos(x: 7, y: 5, z: 2))
        level.append(Pos(x: 8, y: 5, z: 2))
        level.append(Pos(x: 9, y: 5, z: 2))
        level.append(Pos(x: 10, y: 5, z: 2))
        
        level.append(Pos(x: 5, y: 6, z: 2))
        level.append(Pos(x: 6, y: 6, z: 2))
        level.append(Pos(x: 7, y: 6, z: 2))
        level.append(Pos(x: 8, y: 6, z: 2))
        level.append(Pos(x: 9, y: 6, z: 2))
        level.append(Pos(x: 10, y: 6, z: 2))
        
        level.append(Pos(x: 5, y: 7, z: 2))
        level.append(Pos(x: 6, y: 7, z: 2))
        level.append(Pos(x: 7, y: 7, z: 2))
        level.append(Pos(x: 8, y: 7, z: 2))
        level.append(Pos(x: 9, y: 7, z: 2))
        level.append(Pos(x: 10, y: 7, z: 2))
        
        //3
        level.append(Pos(x: 6, y: 3, z: 3))
        level.append(Pos(x: 7, y: 3, z: 3))
        level.append(Pos(x: 8, y: 3, z: 3))
        level.append(Pos(x: 9, y: 3, z: 3))
        
        level.append(Pos(x: 6, y: 4, z: 3))
        level.append(Pos(x: 7, y: 4, z: 3))
        level.append(Pos(x: 8, y: 4, z: 3))
        level.append(Pos(x: 9, y: 4, z: 3))
        
        level.append(Pos(x: 6, y: 5, z: 3))
        level.append(Pos(x: 7, y: 5, z: 3))
        level.append(Pos(x: 8, y: 5, z: 3))
        level.append(Pos(x: 9, y: 5, z: 3))
        
        level.append(Pos(x: 6, y: 6, z: 3))
        level.append(Pos(x: 7, y: 6, z: 3))
        level.append(Pos(x: 8, y: 6, z: 3))
        level.append(Pos(x: 9, y: 6, z: 3))
        
        //4
        level.append(Pos(x: 7, y: 4, z: 4))
        level.append(Pos(x: 8, y: 4, z: 4))
        
        level.append(Pos(x: 7, y: 5, z: 4))
        level.append(Pos(x: 8, y: 5, z: 4))
        
        //--
        level.append(Pos(x: 7.5, y: 4.5, z: 5))
        level.append(Pos(x: 1, y: 4.5, z: 1))
        level.append(Pos(x: 14, y: 4.5, z: 1))
        level.append(Pos(x: 15, y: 4.5, z: 1))

        return level
    }
}
