//
//  HomeViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 5..
//  Copyright © 2018년 박현호. All rights reserved.
//

//  현재 회원가입시 -> member_type , member_nickname 저장
//  현재 로그인시 -> member_ID 저장
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var tapbarSearchBtn: UIButton!
    @IBOutlet weak var tapbarHomeBtn: UIButton!
    @IBOutlet weak var tapbarMemberInfoBtn: UIButton!
    @IBOutlet weak var tapbarUIView: UIView!
    
    var uiviewX : CGFloat?
    
    
    
    @IBOutlet weak var goFirstBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        set()
        setTarget()
        setTapbarAnimation()
    }
    
    func set() {
        
        tapbarUIView.frame.origin.x = uiviewX!
    }
    
    func setTarget() {
        
        //  로그아웃 버튼
        goFirstBtn.addTarget(self, action: #selector(self.pressedGoFirstBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  검색 버튼
        tapbarSearchBtn.addTarget(self, action: #selector(self.pressedTapbarSearchBtn(_:)), for: UIControlEvents.touchUpInside)
        
        //  개인정보 버튼
        tapbarMemberInfoBtn.addTarget(self, action: #selector(self.pressedTapbarMemberInfoBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    //  로그아웃 버튼 액션
    @objc func pressedGoFirstBtn( _ sender : UIButton ) {
        
        self.performSegue(withIdentifier: "signin", sender: self)
    }
    
    //  검색 버튼 액션
    @objc func pressedTapbarSearchBtn( _ sender : UIButton ) {
        
    }
    
    //  개인정보 버튼 액션
    @objc func pressedTapbarMemberInfoBtn( _ sender : UIButton ) {
        
        guard let memberInfoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemberInfoViewController") as? MemberInfoViewController else { return }
        
        memberInfoVC.uiviewX = self.tapbarHomeBtn.frame.origin.x
        
        self.present( memberInfoVC , animated: false , completion: nil )
        
    }
    
    
}
