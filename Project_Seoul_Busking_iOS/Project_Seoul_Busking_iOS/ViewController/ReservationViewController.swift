//
//  ReservationViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ReservationViewController: UIViewController {

    //  유저 정보
    var memberInfo : Member?
    
    //  네비게이션 바
    @IBOutlet weak var reservationNaviUIView: UIView!
    @IBOutlet weak var reservationBackBtn: UIButton!
    
    //  뷰1
    @IBOutlet weak var reservationAreaView: UIView!
    @IBOutlet weak var reservationBoroughLabel: UILabel!
    @IBOutlet weak var reservationBoroughBtn: UIButton!
    var selectBoroughIndex : Int?
    var selectBoroughName : String?
    
    
    @IBOutlet weak var reservationZoneLabel: UILabel!
    @IBOutlet weak var reservationZoneBtn: UIButton!
    
    //  뷰2
    @IBOutlet weak var reservationZoneUIView: UIView!
    @IBOutlet weak var reservationZoneImageView: UIImageView!
    
    //  뷰3
    @IBOutlet weak var reservationDateTimeView: UIView!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var reservationDateBtn: UIButton!
    
    @IBOutlet weak var reservationTimeLabel: UILabel!
    @IBOutlet weak var reservationTimeBtn: UIButton!
    
    //  신청하기
    @IBOutlet weak var reservationCommitBtn: UIButton!
    
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    
    //  자치구 calloutView
    @IBOutlet var boroughListCalloutView: UIView!
    @IBOutlet weak var BoroughListCollectionView: UICollectionView!
    var boroughList : [ Borough ] = [ Borough ]()  //  서버 자치구 리스트
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setTarget()
        setTapbarAnimation()
        
    }

    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        reservationCommitBtn.layer.cornerRadius = 25
        
        if( selectBoroughName != nil ) {
            reservationBoroughLabel.text = selectBoroughName
        }
        
        
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  뒤로가기 버튼
        reservationBackBtn.addTarget(self, action: #selector(self.pressedReservationBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  지역선택 버튼
        reservationBoroughBtn.addTarget(self, action: #selector(self.pressedReservationBoroughBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  위치선택 버튼
        reservationZoneBtn.addTarget(self, action: #selector(self.pressedReservationZoneBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarHomeBtn.frame.origin.x
                
            }, completion: nil )
        })
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
        guard let mapVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else { return }
        
        mapVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        mapVC.memberInfo = self.memberInfo
        
        self.present( mapVC , animated: false , completion: nil )
    }
    
    //  홈 버튼 액션
    @objc func pressedTapbarHomeBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        homeVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        homeVC.memberInfo = self.memberInfo
        
        self.present( homeVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        memberInfoVC.memberInfo = self.memberInfo
        
        self.present( memberInfoVC , animated: false , completion: nil )
    }
    
    //  뒤로가기 버튼 액션
    @objc func pressedReservationBackBtn( _ sender : UIButton ) {
        
        guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        let containerView = self.view.superview
        
        containerView?.addSubview(homeVC.view )
        containerView?.sendSubview(toBack: homeVC.view)
        
        homeVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        homeVC.memberInfo = self.memberInfo
        
        UIView.animate(withDuration: 0.5 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            self.view.frame.origin.x = 375
            
        }) { (finished ) in
            
            self.present( homeVC , animated: false , completion:  nil)
        }
    }
    
    //  자치구 선택 버튼 액션
    @objc func pressedReservationBoroughBtn( _ sender : UIButton ) {
        
        guard let boroughListPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoroughListPopUpViewController") as? BoroughListPopUpViewController else { return }

        boroughListPopUpVC.memberInfo = self.memberInfo

        self.addChildViewController( boroughListPopUpVC )
        boroughListPopUpVC.view.frame = self.view.frame
        self.view.addSubview( boroughListPopUpVC.view )
        boroughListPopUpVC.didMove(toParentViewController: self )
    }
    
    //  위치 선택 버튼 액션
    @objc func pressedReservationZoneBtn( _ sender : UIButton ) {
        
        
        if( reservationBoroughLabel.text == "지역 선택" ) {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "지역을 선택해 주세요."
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
            
        } else {
            
            //  zone 연결
        }
    }


}
