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
    static func reqCalendar( completion : @escaping ( CustomCalendar , _ status : Int ) -> Void ) {
        
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
    
    //  버스킹존 리스트 전부 가져오기
    static func reqBuskingZoneListAll( completion : @escaping ([BuskingZoneAll] , _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/buskingZoneListAll" )
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let buskingZoneAllData = try decoder.decode(BuskingZoneAllData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( buskingZoneAllData.data! , 200 )
                        }
                        else{
                            
                            completion( buskingZoneAllData.data! , 500 )
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
    
    
    //  예약가능한 시간 가져오기
    static func reqReservationPossibility( r_date : Int , sb_id : Int , sbz_id : Int , completion : @escaping ( ReservationPossibility , _ status : Int ) -> Void ) {
        
        let URL = url( "/reservation/possibility?r_date=\(r_date)&sb_id=\(sb_id)&sbz_id=\(sbz_id)" )
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let reservationPossibilityData = try decoder.decode(ReservationPossibilityData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( reservationPossibilityData.data! , 200 )
                        }
                        else{
                            
                            completion( reservationPossibilityData.data! , 500 )
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
    
    //  예약 시도
    static func reqReservationAttempt( r_date : Int , r_startTime : Int , r_endTime : Int , r_category : String ,sb_id : Int , sbz_id : Int , member_nickname : String , completion : @escaping (_ status : Int ) -> Void ) {

        let URL = url( "/reservation/attempt" )

        let body: [String: Any] = [
            "r_date" : r_date ,
            "r_startTime" : r_startTime ,
            "r_endTime" : r_endTime ,
            "r_category" : r_category ,
            "sb_id" : sb_id ,
            "sbz_id" : sbz_id ,
            "member_nickname" : member_nickname
        ]

        Alamofire.request(URL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in

            switch res.result {

            case .success:

                if( res.response?.statusCode == 201 ){
                    completion( 201 )
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
    
    //  예약 리스트 가져오기
    static func reqReservationList( r_date : Int , sb_id : Int , sbz_id : Int , completion : @escaping ( [ Reservation ] , _ status : Int ) -> Void ) {
        
        let URL = url( "/reservation/list?r_date=\(r_date)&sb_id=\(sb_id)&sbz_id=\(sbz_id)" )
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let reservationData = try decoder.decode(ReservationData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( reservationData.data! , 200 )
                        }
                        else{
                            
                            completion( reservationData.data! , 500 )
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
    
    //  현재 예약 전부 가져오기
    static func reqCurrentReservationListAll( r_date : Int , r_time : Int ,  completion : @escaping ([CurrentReservationAll] , _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/currentList?r_date=\(r_date)&r_time=\(r_time)" )
        
        Alamofire.request(URL, method: .get , parameters: nil, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let currentReservationAllData = try decoder.decode(CurrentReservationAllData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( currentReservationAllData.data! , 200 )
                        }
                        else{
                            
                            completion( currentReservationAllData.data! , 500 )
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
    
    //  대표자치구 변경
    static func reqUpdateMemberBorough( member_nickname : String , sb_id : Int , completion : @escaping (_ status : Int ) -> Void ) {
        
        let URL = url( "/member/update/borough" )
        
        let body: [String: Any] = [
            "member_nickname" : member_nickname ,
            "sb_id" : sb_id
        ]
        
        Alamofire.request(URL, method: .put, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if( res.response?.statusCode == 201 ){
                    completion( 201 )
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
    
    //  해당되는 선택1 , 선택2 에 대한 랭킹 리스트 가져오기
    static func reqRankingList( select1 : String , select2 : String , completion : @escaping ( [Ranking] , _ status : Int ) -> Void ) {
  
        let URL = url( "/collection/rankingList" )
        
        let body: [String: Any] = [
            "select1" : select1 ,
            "select2" : select2
        ]

        Alamofire.request(URL, method: .post , parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let rankingData = try decoder.decode(RankingData.self , from: value)
                        
                        if( res.response?.statusCode == 201 ){
                            
                            completion( rankingData.data! , 201 )
                        }
                        else{
                            
                            completion( rankingData.data! , 500 )
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

    //  팔로잉하는지 확인( 200 => 1.  401 => 0 )
    static func reqIsFollowing( member_follow_nickname : String , member_following_nickname : String , completion : @escaping ( _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/isFollowing" )
        
        let body: [String: Any] = [
            "member_follow_nickname" : member_follow_nickname ,
            "member_following_nickname" : member_following_nickname
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
    
    //  팔로잉 하기( 201 => 1.  401 => 0 )
    static func reqFollowing( member_follow_nickname : String , member_following_nickname : String , completion : @escaping ( _ status : Int , _ flag : Int ) -> Void ) {
        
        let URL = url( "/member/following" )
        
        let body: [String: Any] = [
            "member_follow_nickname" : member_follow_nickname ,
            "member_following_nickname" : member_following_nickname
        ]
        
        Alamofire.request(URL, method: .put, parameters: body, encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if( res.response?.statusCode == 201 ){
                    
                    if let value = res.result.value {
                        let following = JSON(value)["following"].int
                        
                        if( following == 1 ) {
                            completion( 201 , 1 )
                        } else if( following == 0 ) {
                            completion( 201 , 0 )
                        }
                    }
                }
                else {
                    completion(500 , 0 )
                }
                break
                
            case .failure(let err):
                print(err.localizedDescription)
                break
            }

        }
    }

    //  멤버 리스트 가져오기
    static func reqMemberList( completion : @escaping ( [MemberList] , _ status : Int ) -> Void ) {
        
        let URL = url( "/collection/memberList" )
        
        Alamofire.request(URL, method: .get , parameters: nil , encoding: JSONEncoding.default, headers: nil).responseData() { res in
            
            switch res.result {
                
            case .success:
                
                if let value = res.result.value {
                    
                    let decoder = JSONDecoder()
                    
                    do {
                        
                        let memberListData = try decoder.decode(MemberListData.self , from: value)
                        
                        if( res.response?.statusCode == 200 ){
                            
                            completion( memberListData.data! , 200 )
                        }
                        else{
                            
                            completion( memberListData.data! , 500 )
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





























