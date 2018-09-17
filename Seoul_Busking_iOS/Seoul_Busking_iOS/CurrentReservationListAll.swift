//
//  CurrentReservationListAll.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 31..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct CurrentReservationAll: Codable {
    
    let sbz_id : Int?
    let r_startTime : Int?
    let r_startMin : Int?
    let r_endTime : Int?
    let r_endMin : Int?
    let r_category : String?
    let member_profile : String?
    let member_nickname : String?
    let member_score : Double?
}

struct CurrentReservationAllData: Codable {
    
    let status: String
    let data: [CurrentReservationAll]?
    let message: String
}
