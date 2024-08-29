//
//  DoskaItem.swift
//  Mahjong
//
//  Created by Алексей Химунин on 29.08.2024.
//

import Foundation
import AppKit

struct DoskaItem{
    let name: String
    let diffuseName: String
    let normalName: String
    let roughnNameess: String
}

extension DoskaItem {
    static func create() -> [DoskaItem] {
        var items = [DoskaItem]()
        //--
        items.append(DoskaItem(name: "Book", diffuseName: "book_pattern_col1_1k", normalName: "book_pattern_nor_gl_1k", roughnNameess: "book_pattern_rough_1k"))
        items.append(DoskaItem(name: "Wood", diffuseName: "TexturesCom_Wood_TeakVeneer_512_albedo", normalName: "TexturesCom_Wood_TeakVeneer_512_normal", roughnNameess: "TexturesCom_Wood_TeakVeneer_512_roughness"))
        //items.append(DoskaItem(name: "", diffuseName: "", normalName: "", roughnNameess: ""))
        //--
        return items
    }
    
    static func defaultName() -> String {
        return "Book"
    }
    
    static func getItem(by name: String) -> DoskaItem? {
        for item in create() {
            if item.name == name {
                return item
            }
        }
        return nil
    }
}

class NSMenuDoskaItem: NSMenuItem{
    var item: DoskaItem!
}
