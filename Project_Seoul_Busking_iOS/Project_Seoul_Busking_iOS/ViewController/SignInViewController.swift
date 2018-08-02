//
//  SignInViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInID: UITextField!
    @IBOutlet weak var signInPassword: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTarget()
        hideKeyboardWhenTappedAround()
    }
    
    func settingTarget() {
        
        signInBtn.addTarget(self, action: #selector(self.pressedSignInBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpBtn.addTarget(self, action: #selector(self.pressedSignUpBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func pressedSignInBtn( _ sender : UIButton ) {
        
        //  로그인
    }
    
    @objc func pressedSignUpBtn( _ sender : UIButton ) {
        
        guard let signUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectTypeViewController") as? SelectTypeViewController else { return }
        
        self.present( signUpVC , animated: true , completion: nil )
    }
    
}


