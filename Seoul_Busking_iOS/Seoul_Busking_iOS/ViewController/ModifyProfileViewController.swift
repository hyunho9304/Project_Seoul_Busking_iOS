//
//  ModifyProfileViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 17..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ModifyProfileViewController: UIViewController {

    //  넘어온 정보
    var memberInfo : Member?
    var memberInfoBasic : MemberInfoBasic?  //  멤버 기본 정보 서버
    
    //  네비게이션 바
    @IBOutlet weak var memberModifyProfilesBackBtn: UIButton!
    
    
    
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
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  백 버튼
        memberModifyProfilesBackBtn.addTarget(self, action: #selector(self.pressedMemberModifyProfilesBackBtn(_:)), for: UIControlEvents.touchUpInside)

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
    
    //  백 버튼 액션
    @objc func pressedMemberModifyProfilesBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: false , completion: nil )
    }

}