//
//  Ranking.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 5..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Ranking: Codable {
    
    let member_num : Int?
    let member_profile : String?
    let member_nickname : String?
    let member_category : String?
}

struct RankingData: Codable {
    
    let status: String
    let data: [Ranking]?
    let message: String
}
