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
    
    //  회원가입
    static func reqSignUp( member_type : String , member_category : String = "" , member_ID : String , member_PW : String , member_nickname : String , member_profile : UIImage  ,  completion : @escaping (_ status : Int ) -> Void ) {
     
        let URL = url( "/member/signup" )

        let memberTypeData = member_type.data(using: .utf8 )
        let memberCategoryData = member_category.data(using: .utf8 )
        let memberIDData = member_ID.data(using: .utf8 )
        let memberPWData = member_PW.data(using: .utf8 )
        let memberNicknameData = member_nickname.data(using: .utf8 )
        let memberProfileData = UIImageJPEGRepresentation( member_profile , 0.3 )
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            multipartFormData.append( memberTypeData! , withName : "member_type" )
            multipartFormData.append( memberCategoryData!, withName: "member_category" )
            multipartFormData.append( memberIDData!, withName: "member_ID" )
            multipartFormData.append( memberPWData! , withName : "member_PW" )
            multipartFormData.append( memberNicknameData!, withName: "member_nickname" )
            multipartFormData.append( memberProfileData!, withName: "member_profile" , fileName:"member_profile.jpg" , mimeType : "image/jpeg")
            
        }, to: URL, method: .post, headers: nil) { (encodingResult) in
            
            switch encodingResult {
                
            case .success(request: let upload , streamingFromDisk: _, streamFileURL: _) :
                
                upload.responseData(completionHandler: { (res) in
                    switch res.result {
                        
                    case .success :
                        
                        if( res.response?.statusCode == 201){
                            completion(201)
                        }
                        else {
                            completion(500)
                        }
                        
                        break
                        
                    case.failure(let err) :
                        print( err.localizedDescription)
                    }
                })
                
            case .failure(let err ) :
                print( err.localizedDescription)
            }
        }
    }
    
}
