//
//  ItemType.swift
//  MacOS-Mahjong-1
//
//  Created by Алексей Химунин on 20.07.2023.
//

import Foundation

enum ItemType: CaseIterable {
    case sou1
    case sou2
    case sou3
    case sou4
    case sou5
    case sou6
    case sou7
    case sou8
    case sou9
    
    case man1
    case man2
    case man3
    case man4
    case man5
    case man6
    case man7
    case man8
    case man9
    
    case pin1
    case pin2
    case pin3
    case pin4
    case pin5
    case pin6
    case pin7
    case pin8
    case pin9
    
    case chun
    case haku
    case hatsu
    case nan
    case pei
    case shaa
    case ton
    
    case flow1
    case flow2
}

extension ItemType {
    var imageName: String{
        switch self{
        case .sou1:
            return "Sou1"
        case .sou2:
            return "Sou2"
        case .sou3:
            return "Sou3"
        case .sou4:
            return "Sou4"
        case .sou5:
            return "Sou5"
        case .sou6:
            return "Sou6"
        case .sou7:
            return "Sou7"
        case .sou8:
            return "Sou8"
        case .sou9:
            return "Sou9"
        case .man1:
            return "Man1"
        case .man2:
            return "Man2"
        case .man3:
            return "Man3"
        case .man4:
            return "Man4"
        case .man5:
            return "Man5"
        case .man6:
            return "Man6"
        case .man7:
            return "Man7"
        case .man8:
            return "Man8"
        case .man9:
            return "Man9"
        case .pin1:
            return "Pin1"
        case .pin2:
            return "Pin2"
        case .pin3:
            return "Pin3"
        case .pin4:
            return "Pin4"
        case .pin5:
            return "Pin5"
        case .pin6:
            return "Pin6"
        case .pin7:
            return "Pin7"
        case .pin8:
            return "Pin8"
        case .pin9:
            return "Pin9"
        case .chun:
            return "Chun"
        case .haku:
            return "Haku"
        case .hatsu:
            return "Hatsu"
        case .nan:
            return "Nan"
        case .pei:
            return "Pei"
        case .shaa:
            return "Shaa"
        case .ton:
            return "Ton"
        case .flow1:
            return "flow1"
        case .flow2:
            return "flow2"
        }
    }
}
