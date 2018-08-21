//
//  CalendarVars.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 22..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation

let date = Date()
let calendar = Calendar.current

var year = calendar.component(.year, from: date)
var month = calendar.component(.month, from: date) - 1
let weekday = calendar.component(.weekday, from: date)
let day = calendar.component(.day, from: date)

