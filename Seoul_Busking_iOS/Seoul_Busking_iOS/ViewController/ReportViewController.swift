//
//  ReportViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController , UITextFieldDelegate , UITextViewDelegate {

    //  넘어온 정보
    var memberInfo : Member?
    var selectMemberNickname : String?      //  선택한 타인 닉네임
    
    //  네비게이션 바
    @IBOutlet weak var reportBackBtn: UIButton!
    
    //  제목
    @IBOutlet weak var reportTitleUIView: UIView!
    @IBOutlet weak var reportTitleTextField: UITextField!
    
    //  내용
    @IBOutlet weak var reportContentUIView: UIView!
    @IBOutlet weak var reportContentTextView: UITextView!
    
    //  작성하기 버튼
    @IBOutlet weak var reportCommitBtn: UIButton!
    
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
        setDelegate()
        setReturnType()
        setTarget()
        
        hideKeyboardWhenTappedAround()
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
        
        reportTitleUIView.layer.cornerRadius = 8    //  둥근정도
        reportTitleUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        reportTitleUIView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)             //  그림자 색
        reportTitleUIView.layer.shadowOpacity = 0.11                          //  그림자 투명도
        reportTitleUIView.layer.shadowOffset = CGSize(width: 0 , height: 1 )    //  그림자 x y
        reportTitleUIView.layer.shadowRadius = 15
        
        reportContentUIView.layer.cornerRadius = 8    //  둥근정도
        reportContentUIView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ] //  radius 줄 곳
        reportContentUIView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)             //  그림자 색
        reportContentUIView.layer.shadowOpacity = 0.11                          //  그림자 투명도
        reportContentUIView.layer.shadowOffset = CGSize(width: 0 , height: 1 )    //  그림자 x y
        reportContentUIView.layer.shadowRadius = 15
        
        reportCommitBtn.layer.cornerRadius = 25
        
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
        reportBackBtn.addTarget(self, action: #selector(self.pressedMemberReportBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  작성하기 버튼
        reportCommitBtn.addTarget(self, action: #selector(self.pressedReportCommitBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  취소 버튼
        alertCancelBtn.addTarget(self, action: #selector(self.pressedAlertCancelBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  확인 버튼
        alertCommitBtn.addTarget(self, action: #selector(self.pressedAlertCommitBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func setDelegate() {
        
        reportTitleTextField.delegate = self
        reportContentTextView.delegate = self
    }
    
    func setReturnType() {
        
        reportTitleTextField.returnKeyType = UIReturnKeyType.done
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
    @objc func pressedMemberReportBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true , completion: nil )
    }
    
    //  작성하기 버튼 액션
    @objc func pressedReportCommitBtn( _ sender : UIButton ) {
        
        if( reportTitleTextField.text != "신고 사유" && reportContentTextView.text != "세부 내용" ) {
            
            self.alertUIView.isHidden = false
            self.backUIView.isHidden = false
            
            self.alertUIView.transform = CGAffineTransform( scaleX: 1.3 , y: 1.3 )
            self.alertUIView.alpha = 0.0
            UIView.animate(withDuration: 0.18) {
                self.alertUIView.alpha = 1.0
                self.alertUIView.transform = CGAffineTransform( scaleX: 1.0 , y: 1.0 )
            }
            
        } else {
            
            guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
            
            defaultPopUpVC.content = "모두 입력해주세요"
            
            self.addChildViewController( defaultPopUpVC )
            defaultPopUpVC.view.frame = self.view.frame
            self.view.addSubview( defaultPopUpVC.view )
            defaultPopUpVC.didMove(toParentViewController: self )
        }
    }
    
    //  취소 버튼 액션
    @objc func pressedAlertCancelBtn( _ sender : UIButton ) {
        
        backUIView.isHidden = true
        alertUIView.isHidden = true
    }
    
    //  확인 버튼 액션
    @objc func pressedAlertCommitBtn( _ sender : UIButton ) {
        
        Server.reqMemberReport(report_fromNickname: (self.memberInfo?.member_nickname)! , report_toNickname: self.selectMemberNickname! , report_title: self.reportTitleTextField.text! , report_content: self.reportContentTextView.text!) { ( rescode ) in
            
            if( rescode == 201 ) {
                
                self.backUIView.isHidden = true
                self.alertUIView.isHidden = true
                
                self.dismiss(animated: false , completion: nil )
                
            } else {
                
                let alert = UIAlertController(title: "서버", message: "통신상태를 확인해주세요", preferredStyle: .alert )
                let ok = UIAlertAction(title: "확인", style: .default, handler: nil )
                alert.addAction( ok )
                self.present(alert , animated: true , completion: nil)
            }
        }
    }
    
    //  Mark -> UITextField Delegate
    //  키보드 확인 눌렀을 때
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        view.endEditing(true)
        return true
    }
    
    //  title 선택시 default 글 지우기
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if( textField.text == "신고 사유" ) {
            textField.text = nil
        }
    }
    
    //  Mark -? UITextView Delegate
    //  키보드 확인 눌렀을 때
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        
        view.endEditing(true)
        return true
    }
    
    //  content 선택시 default 글 지우기
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if( textView.text == "세부 내용" ) {
            textView.text = nil
        }
    }
    




}






