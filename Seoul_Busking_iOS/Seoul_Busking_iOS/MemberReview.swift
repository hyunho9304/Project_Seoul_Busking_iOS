//
//  MemberReview.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 16..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct MemberReview: Codable {
    
    let review_title : String?
    let review_uploadtime : String?
    let review_score : Int?
    let review_fromNickname : String?
    let member_profile : String?
    let review_content : String?
}

struct MemberReviewData: Codable {
    
    let status: String
    let member_score : Double
    let totalCnt : Int
    let scoreCnt : [Int]
    let data: [MemberReview]?
    let message: String
}
