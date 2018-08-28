//
//  Reservation.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 28..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Reservation: Codable {
    
    let r_startTime : Int?
    let r_endTime : Int?
    let member_profile : String?
    let member_nickname : String?
    let member_category : String?
}

struct ReservationData: Codable {
    
    let status: String
    let data: [Reservation]?
    let message: String
}
