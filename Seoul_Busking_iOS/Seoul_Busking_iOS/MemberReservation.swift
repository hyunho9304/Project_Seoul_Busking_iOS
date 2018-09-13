//
//  MemberReservation.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 12..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct MemberReservation: Codable {
    
    let r_id : Int?
    let r_date : Int
    let r_startTime : Int?
    let r_endTime : Int?
    let sb_name : String?
    let sbz_name : String?
    let sbz_address : String?
    let sbz_photo : String?
    let sbz_longitude : Double?
    let sbz_latitude : Double?
}

struct MemberReservationData: Codable {
    
    let status: String
    let data: [MemberReservation]?
    let message: String
}
