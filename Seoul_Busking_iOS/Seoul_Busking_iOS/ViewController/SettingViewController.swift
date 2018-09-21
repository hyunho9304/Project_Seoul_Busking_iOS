//
//  SettingViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    //  넘어온 정보
    var memberInfo : Member?
    var memberInfoBasic : MemberInfoBasic?  //  멤버 기본 정보 서버
    
    //  네비게이션 바
    @IBOutlet weak var settingBackBtn: UIButton!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    //  내용
    @IBOutlet weak var settingNicknameLabel: UILabel!
    @IBOutlet weak var settingIDLabel: UILabel!
    @IBOutlet weak var settingReqBuskerUIView: UIView!
    @IBOutlet weak var settingNoticeUIView: UIView!
    @IBOutlet weak var settingLogoutUIView: UIView!
    
    //  popView
    @IBOutlet weak var alertUIView: UIView!
    @IBOutlet weak var alertCancelBtn: UIButton!
    @IBOutlet weak var alertCommitBtn: UIButton!
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
    }
    
    func set() {
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        settingNicknameLabel.text = self.memberInfoBasic?.member_nickname
        
        settingIDLabel.text = self.memberInfo?.member_ID
        
        backUIView.isHidden = true
        backUIView.backgroundColor = UIColor.black.withAlphaComponent( 0.6 )
        alertUIView.isHidden = true
        alertUIView.layer.cornerRadius = 5    //  둥근정도
        alertUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        
        alertUIView.layer.shadowColor = UIColor.black.cgColor             //  그림자 색
        alertUIView.layer.shadowOpacity = 0.15                            //  그림자 투명도
        alertUIView.layer.shadowOffset = CGSize(width: 0 , height: 3 )    //  그림자 x y
        alertUIView.layer.shadowRadius = 5                                //  그림자 둥근정도
        //  그림자의 블러는 5 정도 이다
        
        //        okBtn.clipsToBounds = true    안에 있는 글 잘린다
        alertCommitBtn.layer.cornerRadius = 5
        alertCommitBtn.layer.maskedCorners = [.layerMaxXMaxYCorner ]
        
        alertCancelBtn.layer.cornerRadius = 5
        alertCancelBtn.layer.maskedCorners = [ .layerMinXMaxYCorner ]

        
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  백 버튼
        settingBackBtn.addTarget(self, action: #selector(self.pressedSettingBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  버스커 신청 뷰
        let tapReqBusker = UITapGestureRecognizer(target: self , action: #selector( self.pressedSettingReqBuskerUIView(_:) ))
        settingReqBuskerUIView.isUserInteractionEnabled = true
        settingReqBuskerUIView.addGestureRecognizer(tapReqBusker)
        
        //  버스커 신청 뷰
        let tapNotice = UITapGestureRecognizer(target: self , action: #selector( self.pressedSettingNoticeUIView(_:) ))
        settingNoticeUIView.isUserInteractionEnabled = true
        settingNoticeUIView.addGestureRecognizer(tapNotice)
        
        //  버스커 신청 뷰
        let tapLogout = UITapGestureRecognizer(target: self , action: #selector( self.pressedSettingLogoutUIView(_:) ))
        settingLogoutUIView.isUserInteractionEnabled = true
        settingLogoutUIView.addGestureRecognizer(tapLogout)
        
        //  취소 버튼
        alertCancelBtn.addTarget(self, action: #selector(self.pressedAlertCancelBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  확인 버튼
        alertCommitBtn.addTarget(self, action: #selector(self.pressedAlertCommitBtn(_:)), for: UIControlEvents.touchUpInside)
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
        
        
        homeVC.uiviewX = self.tapbarMemberInfoBtn.frame.origin.x
        homeVC.memberInfo = self.memberInfo
        
        self.present( homeVC , animated: false , completion: nil )
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true , completion: nil )
        
    }
    
    //  백 버튼 액션
    @objc func pressedSettingBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true , completion: nil )
    }
    
    //  버스커 신청 뷰 액션
    @objc func pressedSettingReqBuskerUIView( _ sender : UIView ) {
        
        print("버스커 신청 이동")
        
    }
    
    //  공지사항 뷰 액션
    @objc func pressedSettingNoticeUIView( _ sender : UIView ) {
        
        guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
        
        defaultPopUpVC.content = "공지사항이 없습니다"
        
        self.addChildViewController( defaultPopUpVC )
        defaultPopUpVC.view.frame = self.view.frame
        self.view.addSubview( defaultPopUpVC.view )
        defaultPopUpVC.didMove(toParentViewController: self )
    }
    
    //  로그아웃 뷰 액션
    @objc func pressedSettingLogoutUIView( _ sender : UIView ) {
    
        self.alertUIView.isHidden = false
        self.backUIView.isHidden = false
        
        self.alertUIView.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
        self.alertUIView.alpha = 0.0
        UIView.animate(withDuration: 0.18) {
            self.alertUIView.alpha = 1.0
            self.alertUIView.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
        }
    }
    
    //  취소 버튼 액션
    @objc func pressedAlertCancelBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
    }
    
    //  확인 버튼 액션
    @objc func pressedAlertCommitBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
        
        self.performSegue(withIdentifier: "logout", sender: self)
    }

    //  로그아웃 버튼 액션
    @objc func presseLogoutBtn( _ sender : UIButton ) {
        
        self.performSegue(withIdentifier: "logout", sender: self)
    }



}
