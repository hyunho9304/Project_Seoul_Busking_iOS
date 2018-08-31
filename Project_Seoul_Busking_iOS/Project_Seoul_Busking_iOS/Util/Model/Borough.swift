//
//  Borough.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Borough: Codable {
    
    let sb_id : Int?
    let sb_name : String?
    let sb_longitude : Double?
    let sb_latitude : Double?
}

struct BoroughData: Codable {
    
    let status: String
    let data: [Borough]?
    let message: String
}
