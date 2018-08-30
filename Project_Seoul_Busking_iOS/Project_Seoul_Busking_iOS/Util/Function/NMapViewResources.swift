//
//  NMapViewResources.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 29..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

// set custom POI Flag Type.
// NMapPOIflagTypeReserved 보다 큰 값으로 설정.
let UserPOIflagTypeDefault: NMapPOIflagType = NMapPOIflagTypeReserved + 1
let UserPOIflagTypeInvisible: NMapPOIflagType = NMapPOIflagTypeReserved + 2

class NMapViewResources: NSObject {
    
    open static func imageWithType(_ poiFlagType: NMapPOIflagType, selected: Bool) -> UIImage? {
        switch poiFlagType {
        case NMapPOIflagTypeLocation:
            return #imageLiteral(resourceName: "mylocationActive")
        case NMapPOIflagTypeLocationOff:
            return #imageLiteral(resourceName: "mylocation")
        case NMapPOIflagTypeCompass:
            return #imageLiteral(resourceName: "mylocationWay")
        case UserPOIflagTypeDefault:
            return #imageLiteral(resourceName: "pin")
        case UserPOIflagTypeInvisible:
            return #imageLiteral(resourceName: "1px_dot")
        default:
            return nil
        }
    }
    
    open static func anchorPoint(withType type: NMapPOIflagType) -> CGPoint {
        switch type {
        case NMapPOIflagTypeLocation: fallthrough
        case NMapPOIflagTypeLocationOff: fallthrough
        case NMapPOIflagTypeCompass:
            return CGPoint(x: 0.5, y: 0.5)
        case UserPOIflagTypeDefault:
            return CGPoint(x: 0.5, y: 1.0)
        case UserPOIflagTypeInvisible:
            return CGPoint(x: 0.5, y: 0.5)
        default:
            return CGPoint(x: 0.5, y: 0.5)
        }
    }
}
