//
//  ReservationViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 20..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit
import Kingfisher

class ReservationViewController: UIViewController {

    //  처음인지 설정
    var first : Bool?
    var fl : Bool?
    
    //  유저 정보
    var memberInfo : Member?
    
    //  네비게이션 바
    @IBOutlet weak var reservationNaviUIView: UIView!
    @IBOutlet weak var reservationBackBtn: UIButton!
    
    //  뷰1
    @IBOutlet weak var reservationAreaView: UIView!
    @IBOutlet weak var reservationBoroughLabel: UILabel!
    @IBOutlet weak var reservationBoroughBtn: UIButton!
    var selectedBoroughIndex : Int?
    var selectedBoroughName : String?
    var selectedBoroughLongitude : Double? //  선택한 경도
    var selectedBoroughLatitude : Double?  //  선택한 위도
    
    
    @IBOutlet weak var reservationZoneLabel: UILabel!
    @IBOutlet weak var reservationZoneBtn: UIButton!
    
    //  뷰2
    @IBOutlet weak var reservationZoneUIView: UIView!
    @IBOutlet weak var reservationZoneImageView: UIImageView!
    var selectedZoneIndex : Int?      //  멤버가 현재 보고 있는 존 index
    var selectedZoneName : String?    //  멤버가 현재 보고 있는 존 name
    var selectedZoneImage : String?      //  멤버가 현재 보고 있는 존 ImageString
    
    //  뷰3
    @IBOutlet weak var reservationDateTimeView: UIView!
    @IBOutlet weak var reservationDateLabel: UILabel!
    @IBOutlet weak var reservationDateBtn: UIButton!
    var selectedTmpDate : String?
    var selectedDate : Int?
    
    @IBOutlet weak var reservationTimeLabel: UILabel!
    @IBOutlet weak var reservationTimeBtn: UIButton!
    var selectedTmpTime : String?
    var selectedTimeCnt : Int?
    var selectedStartTime : [Int] = [ -1 , -1 ]
    var selectedEndTime : [Int] = [ -1 , -1 ]
    
    @IBOutlet weak var reservationCategoryLabel: UILabel!
    @IBOutlet weak var reservationCategoryBtn: UIButton!
    var selectedCategory : String?
    
    
    
    //  신청하기
    @IBOutlet weak var reservationCommitBtn: UIButton!
    
    //  popView
    @IBOutlet weak var alertNoticeUIView: UIView!
    @IBOutlet weak var alertUIView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertCommitBtn: UIButton!
    @IBOutlet weak var alertNoticeCommitBtn: UIButton!
    @IBOutlet weak var backUIView: UIView!
    
    
    //  텝바
    @IBOutlet weak var tapbarMenuUIView: UIView!
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setTarget()
        setTapbarAnimation()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch : UITouch? = touches.first
        
        if touch?.view == backUIView && alertNoticeUIView.isHidden == true {
            
            backUIView.isHidden = true
            alertUIView.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        viewWillSet()
        
        if( fl == true ) {
            backUIView.isHidden = false
            alertNoticeUIView.isHidden = false
        } else {
            backUIView.isHidden = true
            alertNoticeUIView.isHidden = true
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if( selectedZoneName != nil ) {
            
            UIView.animate(withDuration: 0.15 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.reservationDateTimeView.frame.origin.y = 323 * self.view.frame.height / 667
                
                
            }) { (finished ) in
                
                self.reservationZoneUIView.isHidden = false
            }
            
        } else {
            
            UIView.animate(withDuration: 0.15 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.reservationZoneUIView.isHidden = true
                
                self.reservationDateTimeView.frame.origin.y = 210 * self.view.frame.height / 667
                
            }, completion: nil )
        }
        
        self.reservationDateTimeView.layoutIfNeeded()
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        reservationCommitBtn.isEnabled = false
        reservationCommitBtn.alpha = 0.6
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        
        
        reservationCommitBtn.layer.cornerRadius = 25 * self.view.frame.width / 375
        
        backUIView.backgroundColor = UIColor.black.withAlphaComponent( 0.6 )
        
        alertNoticeUIView.layer.cornerRadius = 8 * self.view.frame.width / 375    //  둥근정도
        alertNoticeUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        
        alertUIView.isHidden = true
        alertUIView.layer.cornerRadius = 5 * self.view.frame.width / 375    //  둥근정도
        alertUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        alertUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        alertUIView.layer.shadowOpacity = 0.15                            //  그림자 투명도
        alertUIView.layer.shadowOffset = CGSize(width: 0 , height: 3 )    //  그림자 x y
        alertUIView.layer.shadowRadius = 5                                //  그림자 둥근정도
        //  그림자의 블러는 5 정도 이다
        
        //        okBtn.clipsToBounds = true    안에 있는 글 잘린다
        alertCommitBtn.layer.cornerRadius = 5 * self.view.frame.width / 375
        alertCommitBtn.layer.maskedCorners = [.layerMaxXMaxYCorner ]
        
    }
    
    func viewWillSet() {
        
        if( selectedBoroughName != nil ) {
            reservationBoroughLabel.text = self.selectedBoroughName
        }
        
        if( selectedTmpDate != nil ) {
            reservationDateLabel.text = self.selectedTmpDate
        }
        
        if( selectedZoneName != nil ) {
            
            reservationZoneLabel.text = self.selectedZoneName
            reservationZoneImageView.kf.setImage( with: URL( string:gsno( selectedZoneImage ) ) )
            reservationZoneImageView.layer.cornerRadius = 5 * self.view.frame.width / 375
            reservationZoneImageView.clipsToBounds = true
        }
        
        if( selectedTmpTime != nil ) {
            reservationTimeLabel.text = self.selectedTmpTime
            reservationTimeLabel.font = UIFont(name: "NotoSans-Regular", size: 14)
        }
        
        if( selectedCategory != nil ) {
            reservationCategoryLabel.text = self.selectedCategory
            reservationCommitBtn.isEnabled = true
            reservationCommitBtn.alpha = 1
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
        let boroughTap = UITapGestureRecognizer(target: self , action: #selector( self.pressedReservationBoroughBtn(_:) ))
        reservationBoroughLabel.isUserInteractionEnabled = true
        reservationBoroughLabel.addGestureRecognizer(boroughTap)
        
        //  위치선택 버튼
        reservationZoneBtn.addTarget(self, action: #selector(self.pressedReservationZoneBtn(_:)), for: UIControlEvents.touchUpInside)
        let zonTap = UITapGestureRecognizer(target: self , action: #selector(self.pressedReservationZoneBtn(_:) ))
        reservationZoneLabel.isUserInteractionEnabled = true
        reservationZoneLabel.addGestureRecognizer(zonTap)
        
        //  날짜선택 버튼
        reservationDateBtn.addTarget(self, action: #selector(self.pressedReservationDateBtn(_:)), for: UIControlEvents.touchUpInside)
        let dateTap = UITapGestureRecognizer(target: self , action: #selector(self.pressedReservationDateBtn(_:) ))
        reservationDateLabel.isUserInteractionEnabled = true
        reservationDateLabel.addGestureRecognizer(dateTap)
        
        //  시간선택 버튼
        reservationTimeBtn.addTarget(self, action: #selector(self.pressedReservationTimeBtn(_:)), for: UIControlEvents.touchUpInside)
        let timeTap = UITapGestureRecognizer(target: self , action: #selector(self.pressedReservationTimeBtn(_:) ))
        reservationTimeLabel.isUserInteractionEnabled = true
        reservationTimeLabel.addGestureRecognizer(timeTap)
        
        //  카테고리 선택 버튼
        reservationCategoryBtn.addTarget(self, action: #selector(self.pressedReservationCategoryBtn(_:)), for: UIControlEvents.touchUpInside)
        let categoryTap = UITapGestureRecognizer(target: self , action: #selector(self.pressedReservationCategoryBtn(_:) ))
        reservationCategoryLabel.isUserInteractionEnabled = true
        reservationCategoryLabel.addGestureRecognizer(categoryTap)
        
        //  확인 버튼
        alertCommitBtn.addTarget(self, action: #selector(self.pressedAlertCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  공지 숙지 확인 버튼
        alertNoticeCommitBtn.addTarget(self, action: #selector(self.pressedAlertNoticeCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  신청하기 버튼
        reservationCommitBtn.addTarget(self, action: #selector(self.pressedReservationCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
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
        
        UIView.animate(withDuration: 0.3 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
            
            self.view.frame.origin.x = self.view.frame.width
            
        }) { (finished ) in
            
            self.present( homeVC , animated: false , completion:  nil)
        }
    }
    
    //  자치구 선택 버튼 액션
    @objc func pressedReservationBoroughBtn( _ sender : UIButton ) {
        
        self.reservationZoneUIView.isHidden = true
        
        guard let boroughListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BoroughListViewController") as? BoroughListViewController else { return }
        
        
        boroughListVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        boroughListVC.memberInfo = self.memberInfo
        boroughListVC.selectedBoroughIndex = self.selectedBoroughIndex
        boroughListVC.selectedBoroughName = self.selectedBoroughName
        boroughListVC.selectedBoroughLongitude = self.selectedBoroughLongitude
        boroughListVC.selectedBoroughLatitude = self.selectedBoroughLatitude
        boroughListVC.selectedZoneIndex = self.selectedZoneIndex
        boroughListVC.selectedZoneName = self.selectedZoneName
        boroughListVC.selectedZoneImage = self.selectedZoneImage
        boroughListVC.selectedTmpDate = self.selectedTmpDate
        boroughListVC.selectedDate = self.selectedDate
        boroughListVC.selectedTmpTime = self.selectedTmpTime
        boroughListVC.selectedTimeCnt = self.selectedTimeCnt
        boroughListVC.selectedStartTime = self.selectedStartTime
        boroughListVC.selectedEndTime = self.selectedEndTime
        boroughListVC.selectedCategory = self.selectedCategory
        
        self.addChildViewController( boroughListVC )
        boroughListVC.view.frame = self.view.frame
        self.view.addSubview( boroughListVC.view )
        boroughListVC.didMove(toParentViewController: self )
    }
    
    //  위치 선택 버튼 액션
    @objc func pressedReservationZoneBtn( _ sender : UIButton ) {
        
        self.reservationZoneUIView.isHidden = true
        
        if( reservationBoroughLabel.text == "지역 선택" ) {
            
            alertTitleLabel.text = "지역을 선택해 주세요"
            backUIView.isHidden = false
            alertUIView.isHidden = false
            
        } else {
            
            guard let buskingZoneListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BuskingZoneListViewController") as? BuskingZoneListViewController else { return }
            
            buskingZoneListVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
            buskingZoneListVC.memberInfo = self.memberInfo
            buskingZoneListVC.selectedBoroughIndex = self.selectedBoroughIndex
            buskingZoneListVC.selectedBoroughName = self.selectedBoroughName
            buskingZoneListVC.selectedBoroughLongitude = self.selectedBoroughLongitude
            buskingZoneListVC.selectedBoroughLatitude = self.selectedBoroughLatitude
            buskingZoneListVC.selectedZoneIndex = self.selectedZoneIndex
            buskingZoneListVC.selectedZoneName = self.selectedZoneName
            buskingZoneListVC.selectedZoneImage = self.selectedZoneImage
            buskingZoneListVC.selectedTmpDate = self.selectedTmpDate
            buskingZoneListVC.selectedDate = self.selectedDate
            buskingZoneListVC.selectedTmpTime = self.selectedTmpTime
            buskingZoneListVC.selectedTimeCnt = self.selectedTimeCnt
            buskingZoneListVC.selectedStartTime = self.selectedStartTime
            buskingZoneListVC.selectedEndTime = self.selectedEndTime
            buskingZoneListVC.selectedCategory = self.selectedCategory
            
            
            self.addChildViewController( buskingZoneListVC )
            buskingZoneListVC.view.frame = self.view.frame
            self.view.addSubview( buskingZoneListVC.view )
            buskingZoneListVC.didMove(toParentViewController: self )
            
        }
    }
    
    //  날짜 선택 버튼 액션
    @objc func pressedReservationDateBtn( _ sender : UIButton ) {
        
        self.reservationZoneUIView.isHidden = true
        
        if( reservationZoneLabel.text == "위치 선택" ) {

            alertTitleLabel.text = "위치를 선택해 주세요"
            backUIView.isHidden = false
            alertUIView.isHidden = false

        } else {

            guard let calendarPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CalendarPopUpViewController") as? CalendarPopUpViewController else { return }
            
            calendarPopUpVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
            calendarPopUpVC.memberInfo = self.memberInfo
            calendarPopUpVC.selectedBoroughIndex = self.selectedBoroughIndex
            calendarPopUpVC.selectedBoroughName = self.selectedBoroughName
            calendarPopUpVC.selectedBoroughLongitude = self.selectedBoroughLongitude
            calendarPopUpVC.selectedBoroughLatitude = self.selectedBoroughLatitude
            calendarPopUpVC.selectedZoneIndex = self.selectedZoneIndex
            calendarPopUpVC.selectedZoneName = self.selectedZoneName
            calendarPopUpVC.selectedZoneImage = self.selectedZoneImage
            calendarPopUpVC.selectedTmpDate = self.selectedTmpDate
            calendarPopUpVC.selectedDate = self.selectedDate
            calendarPopUpVC.selectedTmpTime = self.selectedTmpTime
            calendarPopUpVC.selectedTimeCnt = self.selectedTimeCnt
            calendarPopUpVC.selectedStartTime = self.selectedStartTime
            calendarPopUpVC.selectedEndTime = self.selectedEndTime
            calendarPopUpVC.selectedCategory = self.selectedCategory
            
            self.addChildViewController( calendarPopUpVC )
            calendarPopUpVC.view.frame = self.view.frame
            self.view.addSubview( calendarPopUpVC.view )
            calendarPopUpVC.didMove(toParentViewController: self )

        }
    }
    
    //  시간 선택 버튼 액션
    @objc func pressedReservationTimeBtn( _ sender : UIButton ) {
        
        self.reservationZoneUIView.isHidden = true
        
        if( reservationDateLabel.text == "공연 날짜 선택" ) {
            
            alertTitleLabel.text = "날짜를 선택해 주세요"
            backUIView.isHidden = false
            alertUIView.isHidden = false
            alertNoticeUIView.isHidden = true
            
        } else {
            
            guard let timeTableVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TimeTableViewController") as? TimeTableViewController else { return }
            
            timeTableVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
            timeTableVC.memberInfo = self.memberInfo
            timeTableVC.selectedBoroughIndex = self.selectedBoroughIndex
            timeTableVC.selectedBoroughName = self.selectedBoroughName
            timeTableVC.selectedBoroughLongitude = self.selectedBoroughLongitude
            timeTableVC.selectedBoroughLatitude = self.selectedBoroughLatitude
            timeTableVC.selectedZoneIndex = self.selectedZoneIndex
            timeTableVC.selectedZoneName = self.selectedZoneName
            timeTableVC.selectedZoneImage = self.selectedZoneImage
            timeTableVC.selectedTmpDate = self.selectedTmpDate
            timeTableVC.selectedDate = self.selectedDate
            timeTableVC.selectedTmpTime = self.selectedTmpTime
            timeTableVC.selectedTimeCnt = self.selectedTimeCnt
            timeTableVC.selectedStartTime = self.selectedStartTime
            timeTableVC.selectedEndTime = self.selectedEndTime
            timeTableVC.selectedCategory = self.selectedCategory
            
            self.addChildViewController( timeTableVC )
            timeTableVC.view.frame = self.view.frame
            self.view.addSubview( timeTableVC.view )
            timeTableVC.didMove(toParentViewController: self )
        }
    }

    //  카테고리 선택 버튼 액션
    @objc func pressedReservationCategoryBtn( _ sender : UIButton ) {
        
        self.reservationZoneUIView.isHidden = true
        
        if( reservationTimeLabel.text == "공연 시간 선택" ) {

            alertTitleLabel.text = "시간을 선택해 주세요"
            backUIView.isHidden = false
            alertUIView.isHidden = false
            alertNoticeUIView.isHidden = true
           
        } else {
            
            guard let categoryPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController else { return }
            
            categoryPopUpVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
            categoryPopUpVC.memberInfo = self.memberInfo
            categoryPopUpVC.selectedBoroughIndex = self.selectedBoroughIndex
            categoryPopUpVC.selectedBoroughName = self.selectedBoroughName
            categoryPopUpVC.selectedBoroughLongitude = self.selectedBoroughLongitude
            categoryPopUpVC.selectedBoroughLatitude = self.selectedBoroughLatitude
            categoryPopUpVC.selectedZoneIndex = self.selectedZoneIndex
            categoryPopUpVC.selectedZoneName = self.selectedZoneName
            categoryPopUpVC.selectedZoneImage = self.selectedZoneImage
            categoryPopUpVC.selectedTmpDate = self.selectedTmpDate
            categoryPopUpVC.selectedDate = self.selectedDate
            categoryPopUpVC.selectedTmpTime = self.selectedTmpTime
            categoryPopUpVC.selectedTimeCnt = self.selectedTimeCnt
            categoryPopUpVC.selectedStartTime = self.selectedStartTime
            categoryPopUpVC.selectedEndTime = self.selectedEndTime
            categoryPopUpVC.selectedCategory = self.selectedCategory
            
            self.addChildViewController( categoryPopUpVC )
            categoryPopUpVC.view.frame = self.view.frame
            self.view.addSubview( categoryPopUpVC.view )
            categoryPopUpVC.didMove(toParentViewController: self )
        }
    }
    
    //  확인 버튼 액션
    @objc func pressedAlertCommitBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
        
        if( selectedZoneName != nil ) {
            
            UIView.animate(withDuration: 0.15 , delay: 0 , usingSpringWithDamping: 1 , initialSpringVelocity: 1 , options: .curveEaseOut , animations: {
                
                self.reservationDateTimeView.frame.origin.y = 323 * self.view.frame.height / 667
                
                
            }) { (finished ) in
                
                self.reservationZoneUIView.isHidden = false
            }
            
        } else {
            
            UIView.animate(withDuration: 0.15 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.reservationZoneUIView.isHidden = true
                
                self.reservationDateTimeView.frame.origin.y = 210 * self.view.frame.height / 667
                
            }, completion: nil )
        }
        
        self.reservationDateTimeView.layoutIfNeeded()
    }
    
    //  공지 숙지 확인 버튼 액션
    @objc func pressedAlertNoticeCommitBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
        alertNoticeUIView.isHidden = true
    }
    
    //  신청하기 버튼 액션
    @objc func pressedReservationCommitBtn( _ sender : UIButton ) {
        
        var flag : Int = 0
        
        //  한번의 서버 연동
        if( selectedTimeCnt == 1 ) {
            
            Server.reqReservationAttempt(r_date: selectedDate! , r_startTime: selectedStartTime[0] , r_startMin: 0 , r_endTime: selectedEndTime[0] , r_endMin: 0 , r_category: selectedCategory! , sb_id: selectedBoroughIndex! , sbz_id: selectedZoneIndex! , member_nickname: (memberInfo?.member_nickname)!) { ( rescode ) in
                
                if( rescode == 201 ) {
                    flag += 1
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
                    
                    if( flag == 1 ) {
                        
                        guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                        
                        defaultPopUpVC.memberInfo = self.memberInfo
                        defaultPopUpVC.uiviewX = self.uiviewX
                        defaultPopUpVC.content = "예약이 접수 되었습니다.\n ( 홈으로 이동합니다. )"
                        
                        self.addChildViewController( defaultPopUpVC )
                        defaultPopUpVC.view.frame = self.view.frame
                        self.view.addSubview( defaultPopUpVC.view )
                        defaultPopUpVC.didMove(toParentViewController: self )
                    } else {
                        
                        let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                        let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                        alert.addAction( ok )
                        self.present(alert , animated: true , completion: nil)
                    }
                })
            }
            
        } else {    //  두번의 서버 연동
            
            for i in 0 ..< 2 {
                
                Server.reqReservationAttempt(r_date: selectedDate! , r_startTime: selectedStartTime[i] , r_startMin: 0 , r_endTime: selectedEndTime[i] , r_endMin: 0 , r_category: selectedCategory! , sb_id: selectedBoroughIndex! , sbz_id: selectedZoneIndex! , member_nickname: (memberInfo?.member_nickname)!) { ( rescode ) in
                    
                    if( rescode == 201 ) {
                        flag += 1
                    } else {
                        flag -= 1
                    }
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 , execute: {
              
                if( flag == 2 ) {
                    
                    guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                    
                    defaultPopUpVC.memberInfo = self.memberInfo
                    defaultPopUpVC.uiviewX = self.uiviewX
                    defaultPopUpVC.content = "예약이 접수 되었습니다.\n ( 홈으로 이동합니다. )"
                    
                    self.addChildViewController( defaultPopUpVC )
                    defaultPopUpVC.view.frame = self.view.frame
                    self.view.addSubview( defaultPopUpVC.view )
                    defaultPopUpVC.didMove(toParentViewController: self )
                } else {
                    
                    let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                    alert.addAction( ok )
                    self.present(alert , animated: true , completion: nil)
                }
            })
        }
    }

}
