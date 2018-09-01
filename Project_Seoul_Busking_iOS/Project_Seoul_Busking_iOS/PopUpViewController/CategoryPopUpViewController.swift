//
//  CategoryPopUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 30..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class CategoryPopUpViewController: UIViewController {

    //  넘어온 정보
    var memberInfo : Member?            //  유저 정보
    var selectedBoroughIndex : Int?     //  선택한 자치구 index
    var selectedBoroughName : String?   //  선택한 자치구 name
    var selectedBoroughLongitude : Double?             //  멤버가 선택한 경도
    var selectedBoroughLatitude : Double?              //  멤버가 선택한 위도
    var selectedZoneIndex : Int?        //  멤버가 선택한 존 index
    var selectedZoneName : String?      //  멤버가 선택한 존 name
    var selectedZoneImage : String?     //  멤버가 선택한 존 ImageString
    var selectedTmpDate : String?       //  멤버가 선택한 날짜.
    var selectedDate : Int?          //  멤버가 선택한 날짜
    var selectedTmpTime : String?                   //  멤버가 선택한 시간 글
    var selectedTimeCnt : Int?                      //  멤버가 선택한 시간 개수
    var selectedStartTime : [Int] = [ -1 , -1 ]     //  멤버가 선택한 시간 시작 시간
    var selectedEndTime : [Int] = [ -1 , -1 ]       //  멤버가 선택한 시간 끝나는 시간
    var selectedCategory : String?              //  멤버가 선택한 장르
    var uiviewX : CGFloat?
    
    //  내용
    @IBOutlet weak var popUpViewBackBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showAnimate()
        setTarget()
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.18) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
        }
    }
    
    func setTarget() {

        //  뷰 닫기 버튼
        popUpViewBackBtn.addTarget(self, action: #selector(self.pressedPopUpViewBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    //  뷰 닫기 버튼 액션
    @objc func pressedPopUpViewBackBtn( _ sender : UIButton ) {
        
        guard let reservationVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReservationViewController") as? ReservationViewController else { return }
        
        reservationVC.memberInfo = self.memberInfo
        reservationVC.uiviewX = self.uiviewX
        
        reservationVC.selectedBoroughIndex = self.selectedBoroughIndex
        reservationVC.selectedBoroughName = self.selectedBoroughName
        reservationVC.selectedBoroughLongitude = self.selectedBoroughLongitude
        reservationVC.selectedBoroughLatitude = self.selectedBoroughLatitude
        reservationVC.selectedZoneIndex = self.selectedZoneIndex
        reservationVC.selectedZoneName = self.selectedZoneName
        reservationVC.selectedZoneImage = self.selectedZoneImage
        reservationVC.selectedTmpDate = self.selectedTmpDate
        reservationVC.selectedDate = self.selectedDate
        reservationVC.selectedTmpTime = self.selectedTmpTime
        reservationVC.selectedTimeCnt = self.selectedTimeCnt
        reservationVC.selectedStartTime = self.selectedStartTime
        reservationVC.selectedEndTime = self.selectedEndTime
        reservationVC.selectedCategory = self.selectedCategory
        
        self.present( reservationVC , animated: false , completion: nil )
        
        self.view.removeFromSuperview()
    }
    
    
}










