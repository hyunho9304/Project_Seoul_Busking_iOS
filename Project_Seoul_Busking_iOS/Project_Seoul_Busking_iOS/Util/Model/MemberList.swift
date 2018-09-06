//
//  MemberList.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 6..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct MemberList: Codable {
    
    let member_profile : String?
    let member_nickname : String?
    let member_category : String?
}

struct MemberListData: Codable {
    
    let status: String
    let data: [MemberList]?
    let message: String
}
