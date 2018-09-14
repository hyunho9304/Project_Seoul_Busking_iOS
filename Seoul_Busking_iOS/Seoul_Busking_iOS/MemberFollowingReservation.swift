//
//  MemberFollowingReservation.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 12..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct MemberFollowingReservation: Codable {
    
    let member_profile : String?
    let member_nickname : String?
    let r_category : String?
    let r_date : Int
    let r_startTime : Int?
    let r_endTime : Int?
    let sbz_name : String?
}

struct MemberFollowingReservationData: Codable {
    
    let status: String
    let data: [MemberFollowingReservation]?
    let message: String
}