//
//  BuskingZoneListAll.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 30..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct BuskingZoneAll: Codable {
    
    let sbz_id : Int?
    let sb_name : String?
    let sbz_name : String?
    let sbz_photo : String?
    let sbz_address : String?
    let sbz_longitude : Double?
    let sbz_latitude : Double?
}

struct BuskingZoneAllData: Codable {
    
    let status: String
    let data: [BuskingZoneAll]?
    let message: String
}
