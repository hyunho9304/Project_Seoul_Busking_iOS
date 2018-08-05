//
//  Server.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit

struct Server : APIService {
    
    //  중복체크( 아이디 )
    static func reqOverlapIDCheck( member_ID : String , completion : @escaping (_ status : Int ) -> Void ) {
        
        let URL = url( "/member/overlap/id" )
        
        let body: [String: Any] = [
            "member_ID" : member_ID
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if( res.response?.statusCode == 201 ){
                    completion( 201 )
                }
                else if( res.response?.statusCode == 401 ) {
                    completion( 401 )
                }
                else {
                    completion( 500 )
                }
                break
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //  중복체크( 닉네임 )
    static func reqOverlapNicknameCheck( member_nickname : String , completion : @escaping (_ status : Int ) -> Void ) {
        
        let URL = url( "/member/overlap/nickname" )
        
        let body: [String: Any] = [
            "member_nickname" : member_nickname
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if( res.response?.statusCode == 201 ){
                    completion( 201 )
                }
                else if( res.response?.statusCode == 401 ) {
                    completion( 401 )
                }
                else {
                    completion( 500 )
                }
                break
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
}
