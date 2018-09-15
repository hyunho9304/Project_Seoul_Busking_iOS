//
//  ReviewDetailViewController.swift
//  Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 9. 15..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class ReviewDetailViewController: UIViewController {

    //  유저 정보
    var memberInfo : Member?
    var selectMemberNickname : String?      //  선택한 타인 닉네임
    
    //  네비게이션 바
    @IBOutlet weak var navigationBackBtn: UIButton!
    
    //  후기 작성 버튼
    @IBOutlet weak var reviewCreateBtn: UIButton!
    @IBOutlet weak var reviewCreateImageBtn: UIButton!
    
    //  별점
    @IBOutlet weak var starPercentileBackUIView5: UIView!
    @IBOutlet weak var starPercentileUIView5: UIView!
    @IBOutlet weak var starPercentileBackUIView4: UIView!
    @IBOutlet weak var starPercentileUIView4: UIView!
    @IBOutlet weak var starPercentileBackUIView3: UIView!
    @IBOutlet weak var starPercentileUIView3: UIView!
    @IBOutlet weak var starPercentileBackUIView2: UIView!
    @IBOutlet weak var starPercentileUIView2: UIView!
    @IBOutlet weak var starPercentileBackUIView1: UIView!
    @IBOutlet weak var starPercentileUIView1: UIView!
    
    
    
    
    
    
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
    
    func set() {
        
        if uiviewX != nil {
            
            tapbarUIView.frame.origin.x = uiviewX!
        }
        
        tapbarMenuUIView.layer.shadowColor = #colorLiteral(red: 0.4941176471, green: 0.5921568627, blue: 0.6588235294, alpha: 1)             //  그림자 색
        tapbarMenuUIView.layer.shadowOpacity = 0.24                            //  그림자 투명도
        tapbarMenuUIView.layer.shadowOffset = CGSize.zero    //  그림자 x y
        //  그림자의 블러는 5 정도 이다
        
        let starPercentileBackUIViewArr = [ starPercentileBackUIView5 , starPercentileBackUIView4 , starPercentileBackUIView3 , starPercentileBackUIView2 , starPercentileBackUIView1 ]
        
        let starPercentileUIView = [ starPercentileUIView5 , starPercentileUIView4 , starPercentileUIView3 , starPercentileUIView2 , starPercentileUIView1 ]
        
        for i in 0 ..< 5 {
            starPercentileBackUIViewArr[i]?.layer.cornerRadius = 5    //  둥근정도
            starPercentileBackUIViewArr[i]?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ]
            starPercentileUIView[i]?.layer.cornerRadius = 5    //  둥근정도
            starPercentileUIView[i]?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner , .layerMinXMinYCorner , .layerMaxXMinYCorner ]
            
        }
        
//        starPercentileUIView5.frame.size.width = 1 / self. * 168

    }
    
    func setTarget() {
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  홈 버튼
        tapbarHomeBtn.addTarget(self, action: #selector(self.pressedTapbarHomeBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  뒤로가기 버튼
        navigationBackBtn.addTarget(self, action: #selector(self.pressedNavigationBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  후기 작성 버튼
        reviewCreateBtn.addTarget(self, action: #selector(self.pressedReviewCreateBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  후기 작성 이미지 버튼
        reviewCreateImageBtn.addTarget(self, action: #selector(self.pressedReviewCreateBtn(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func setTapbarAnimation() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
            
            UIView.animate(withDuration: 0.75 , delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut , animations: {
                
                self.tapbarUIView.frame.origin.x = self.tapbarMemberInfoBtn.frame.origin.x
                
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
    @objc func pressedNavigationBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true , completion: nil )
    }
    
    //  후기 작성 버튼 액션
    @objc func pressedReviewCreateBtn( _ sender : UIButton ) {
        
        guard let reviewCreateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReviewCreateViewController") as? ReviewCreateViewController else { return }
        
        reviewCreateVC.memberInfo = self.memberInfo
        reviewCreateVC.selectMemberNickname = self.selectMemberNickname
        
        self.present( reviewCreateVC , animated: true , completion: nil )
    }

}




















