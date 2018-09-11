//
//  ReservationPossibility.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 27..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct ReservationPossibility : Codable {
    
    let possibility : [Int]
}


struct ReservationPossibilityData : Codable {
    
    let status : String
    let data : ReservationPossibility?
    let message : String
}
