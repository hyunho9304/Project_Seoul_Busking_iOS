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
    static func reqSignUp( member_type : String , member_category : String , member_ID : String , member_PW : String , member_nickname : String , completion : @escaping ( Member , _ status : Int ) -> Void ) {
        
        let URL = url( "/member/signup" )
        
        let body: [String: Any] = [
            "member_type" : member_type ,
            "member_category" : member_category ,
            "member_ID" : member_ID ,
            "member_PW" : member_PW ,
            "member_nickname" : member_nickname
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let memberData = try decoder.decode(MemberData.self , from: value)
                        
                        if( res.response?.statusCode == 201 ){
                            
                            completion( memberData.data! , 201 )
                        }
                        else{
                            
                            completion( memberData.data! , 500 )
                        }
                        
                    } catch {
                        print( "catch err" )
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //  로그인
    static func reqSignIn( member_ID : String , member_PW : String , completion : @escaping ( Member , _ status : Int ) -> Void ) {
        
        let URL = url( "/member/signin" )
        
        let body: [String: Any] = [
            "member_ID" : member_ID ,
            "member_PW" : member_PW
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let memberData = try decoder.decode(MemberData.self , from: value)
                        
                        if( res.response?.statusCode == 201 ){
                            
                            completion( memberData.data! , 201 )
                            
                        } else if( res.response?.statusCode == 401 ) {
                            
                            completion( memberData.data! , 401 )
                        }
                        else{
                            
                            completion( memberData.data! , 500 )
                        }
                        
                    } catch {
                        print( "catch err" )
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }

    //  달력 가져오기
    static func reqCalendar( completion : @escaping ( Calendar , _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/calendarList")
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let calendarData = try decoder.decode(CalendarData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( calendarData.data! , 200 )
                        }
                        else{
                            
                            completion( calendarData.data! , 500 )
                        }
                        
                    } catch {
                        print( "catch err" )
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //  멤버의 대표 자치구 가져오기
    static func reqMemberRepresentativeBorough( member_nickname : String , completion : @escaping ( MemberRepresentativeBorough , _ status : Int ) -> Void ) {
        
        let URL = url( "/member/representativeBorough" )
        
        let body: [String: Any] = [
            "member_nickname" : member_nickname
        ]
        
        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let memberRepresentativeBoroughData = try decoder.decode(MemberRepresentativeBoroughData.self , from: value)
                        
                        if( res.response?.statusCode == 201 ){
                            
                            completion( memberRepresentativeBoroughData.data! , 201 )
                            
                        } else {
                            
                            completion( memberRepresentativeBoroughData.data! , 500 )
                        }
                        
                    } catch {
                        print( "catch err" )
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //  해당되는 자치구의 버스킹존 리스트 가져오기
    static func reqBuskingZoneList( sb_id : Int , completion : @escaping ([BuskingZone] , _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/buskingZoneList?sb_id=\(sb_id)" )
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        
                        let buskingZoneListData = try decoder.decode(BuskingZoneData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( buskingZoneListData.data! , 200 )
                        }
                        else{
                            
                            completion( buskingZoneListData.data! , 500 )
                        }
                        
                    } catch {
                        print( "catch err" )
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
    //  자치구 리스트 가져오기
    static func reqBoroughList( completion : @escaping ( [Borough] , _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/boroughList" )
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        
                        let boroughListData = try decoder.decode(BoroughData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( boroughListData.data! , 200 )
                        }
                        else{
                            
                            completion( boroughListData.data! , 500 )
                        }
                        
                    } catch {
                        print( "catch err" )
                    }
                }
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }
        }
    }
    
}





























