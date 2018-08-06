//
//  HomeViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 5..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //  홈들어왔을때 member_Type 저장해야함 어떤식으로 할지 생각해바야함
    //  현재 회원가입시 -> member_type , member_ID 저장
    //  현재 로그인시 -> member_ID 저장
    //  다른 서버 연동하면서 member 에 대한 기본정보를 가져올것인지 생각해바야함
    
    @IBOutlet weak var goFirstBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
    }
    
    func setTarget() {
        
        goFirstBtn.addTarget(self, action: #selector(self.pressedGoFirstBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedGoFirstBtn( _ sender : UIButton ) {
        
        self.performSegue(withIdentifier: "signin", sender: self)
    }

    
}
