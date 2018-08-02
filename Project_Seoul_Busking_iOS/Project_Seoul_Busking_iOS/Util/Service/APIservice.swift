//
//  APIservice.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

/*
 Description : 통신으로 사용할 ip 와 port 설정
 */

import Foundation

protocol APIService {
    
}

extension APIService {
    
    static func url( _ path : String ) -> String {
        
        return "http://13.124.195.255:3000" + path
    }
}
