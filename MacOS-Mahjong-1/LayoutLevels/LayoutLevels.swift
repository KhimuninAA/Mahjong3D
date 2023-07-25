//
//  LayoutLevels.swift
//  Mahjong
//
//  Created by Алексей Химунин on 25.07.2023.
//

import Foundation

class LayoutLevels {
    private static func load(name: String) -> String? {
        if let filepath = Bundle.main.path(forResource: name, ofType: "layout") {
            do {
                let contents = try String(contentsOfFile: filepath)
                return contents
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }

    static func getLevel(name: String) -> [Pos] {
        var poss = [Pos]()

        if let str = load(name: name) {
            let rows = str.components(separatedBy: "\n")

            var mX: CGFloat = 0
            var mY: CGFloat = 0
            var mZ: CGFloat = 1
            for index in 1...(rows.count-2) {
                mX = 0
                let row = rows[index]
                if row.count > 1 && (row.prefix(1) == "." || row.prefix(1) == "1" || row.prefix(1) == "2" || row.prefix(1) == "3" || row.prefix(1) == "4") {
                    for c in row {
                        if c == "1" {
                            poss.append(Pos(x: mX, y: mY, z: mZ))
                        }
                        mX += 0.5
                    }
                    mY += 0.5
                }
                if row.prefix(7) == "# Level" {
                    if row.prefix(9) != "# Level 0" && mY > 0 {
                        mZ += 1
                    }
                }
                if mY >= 8 {
                    mY = 0
                    mZ += 1
                }
            }
        }

        return poss
    }
}
