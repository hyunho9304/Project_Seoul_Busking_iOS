//
//  BuskingZone.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 16..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct BuskingZone: Codable {

    let sbz_id : Int?
    let sbz_name : String?
    let sbz_photo : String?
    let sbz_address : String?
    let sbz_longitude : Double?
    let sbz_latitude : Double?
}

struct BuskingZoneData: Codable {

    let status: String
    let data: [BuskingZone]?
    let message: String
}
