//
//  MemberInfoBasic.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 11..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct MemberInfoBasic : Codable {
    
    let member_type : String?
    let member_category : String?
    let member_nickname : String?
    let member_backProfile : String?
    let member_profile : String?
    let member_introduction : String?
    let member_score : Double?
    let member_followCnt : Int?
    let member_followingCnt : Int?
}

struct MemberInfoBasicData : Codable {
    
    let status : String
    let data : MemberInfoBasic?
    let message : String
}
