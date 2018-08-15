//
//  Calendar.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

struct Calendar : Codable {
    
    let twoWeeksYear : [ String ]?
    let twoWeeksMonth : [ String ]?
    let twoWeeksDate : [ String ]?
    let twoWeeksDay : [ String ]?
}


struct CalendarData : Codable {
    
    let status : String
    let data : Calendar?
    let message : String
}
