//
//  MemberFollowing.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 14..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct MemberFollowing: Codable {
    
    let member_profile : String?
    let member_nickname : String?
    let member_category : String?
}

struct MemberFollowingData: Codable {
    
    let status: String
    let data: [MemberFollowing]?
    let message: String
}
