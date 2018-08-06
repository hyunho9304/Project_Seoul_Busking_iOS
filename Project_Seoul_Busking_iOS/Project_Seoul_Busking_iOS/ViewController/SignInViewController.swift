//
//  SignInViewController.swift
//  Project_Seoul_Busking_iOS
//
//  Created by 박현호 on 2018. 8. 2..
//  Copyright © 2018년 박현호. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var signInIDTextField: UITextField!
    @IBOutlet weak var signInPWTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    let userdefault = UserDefaults.standard     //  기본회원정보
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTarget()
        confirmWrite()
        hideKeyboardWhenTappedAround()
        
    }
    
    func setTarget() {
        
        signInBtn.addTarget(self, action: #selector(self.pressedSignInBtn(_:)), for: UIControlEvents.touchUpInside)
        signUpBtn.addTarget(self, action: #selector(self.pressedSignUpBtn(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func confirmWrite() {
        
        signInBtn.isEnabled = false  //  default setting
        
        signInIDTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
        signInPWTextField.addTarget(self, action: #selector(isValid), for: .editingChanged)   //  textField
    }
    
    @objc func isValid() {
        
        if( !(signInIDTextField.text?.isEmpty)! && !(signInPWTextField.text?.isEmpty)! ) {
            
            signInBtn.isEnabled = true
            
        } else {
            
            signInBtn.isEnabled = false
        }
    }
    
    @objc func pressedSignInBtn( _ sender : UIButton ) {
        
        userdefault.set( gsno( signInIDTextField.text ) , forKey: "member_ID" )
        
        Server.reqSignIn(member_ID: signInIDTextField.text! , member_PW: signInPWTextField.text!) { ( rescode ) in
            
            if rescode == 201 {
                
                guard let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
                
                self.present( homeVC , animated: true , completion: nil )
                
                
            } else if rescode == 401 {
                
                guard let defaultPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DefaultPopUpViewController") as? DefaultPopUpViewController else { return }
                
                defaultPopUpVC.content = "아이디 또는 비밀번호를 확인해주세요."
                
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
        }
    }
    
    @objc func pressedSignUpBtn( _ sender : UIButton ) {
        
        guard let selectTypeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SelectTypeViewController") as? SelectTypeViewController else { return }
        
        self.present( selectTypeVC , animated: true , completion: nil )
    }
    
    
}


