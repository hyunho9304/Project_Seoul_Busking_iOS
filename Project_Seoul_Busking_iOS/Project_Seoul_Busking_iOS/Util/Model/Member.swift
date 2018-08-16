//
//  Member.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Member : Codable {
    
    let member_type : String?
    var member_nickname : String?
}


struct MemberData : Codable {
    
    let status : String
    let data : Member?
    let message : String
}
