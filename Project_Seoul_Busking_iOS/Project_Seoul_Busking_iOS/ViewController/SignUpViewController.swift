//
//  SignUpViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpBackBtn: UIButton!
    @IBOutlet weak var signUpIDTextField: UITextField!
    @IBOutlet weak var signUpPWTextField: UITextField!
    @IBOutlet weak var signUpNicknameTextField: UITextField!
    @IBOutlet weak var signUpCompletionBtn: UIButton!
    
    @IBOutlet weak var signUpBuskerView: UIView!
    @IBOutlet weak var signUpAudienceView: UIView!
    
    var memberType : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        set()
        setTarget()
    }
    
    func set() {

        if memberType == 1 {
            signUpBuskerView.isHidden = false
        } else {
            signUpAudienceView.isHidden = false
        }
        
    }
    
    func setTarget() {
        
        signUpBackBtn.addTarget(self, action: #selector(self.pressedSignUpBackBtn(_:)), for: UIControlEvents.touchUpInside)
        
        signUpCompletionBtn.addTarget(self, action: #selector(self.pressedSignUpCompletionBtn(_:)), for: UIControlEvents.touchUpInside)
    }

    @objc func pressedSignUpBackBtn( _ sender : UIButton ) {
        
        self.dismiss(animated: true, completion: nil )
    }
    
    @objc func pressedSignUpCompletionBtn( _ sender : UIButton ) {
    
        //  회원가입 서버 진행
    }
}
